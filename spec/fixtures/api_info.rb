require 'http'
require 'yaml'
require 'json'

# config = YAML.safe_load(File.read('config/secrets.yml'))


def get_total_record_num_path
  'http://www.104.com.tw/i/apis/jobsearch.cfm?cat='+'2007001006'+'&order=7'+'&kwop=2'+'&fmt=2'+'&incs=2'+'&cols=JOB%2CNAME%2CLINK%2CLAT%2CLON%2CADDR_NO_DESCRIPT%2CADDRESS'
  # 'http://www.104.com.tw/i/apis/jobsearch.cfm?kws=' + keywords +'&order=7'+'&kwop=2'+'&fmt=2'+'&incs=2'+'&cols=JOB%2CNAME%2CLINK%2CLAT%2CLON%2CADDR_NO_DESCRIPT%2CADDRESS'
end

def api_path(page)
  'http://www.104.com.tw/i/apis/jobsearch.cfm?cat='+'2007001006'+'&order=7'+'&kwop=2'+'&fmt=8'+'&page=' + page.to_s + '&incs=2'+'&cols=JOB%2CNAME%2CLINK%2CLAT%2CLON%2CADDR_NO_DESCRIPT%2CADDRESS'
  # 'http://www.104.com.tw/i/apis/jobsearch.cfm?kws=' + keywords +'&order=7'+'&kwop=2'+'&fmt=8'+'&page=' + page.to_s + '&incs=2'+'&cols=JOB%2CNAME%2CLINK%2CLAT%2CLON%2CADDR_NO_DESCRIPT%2CADDRESS'
  # 'http://www.104.com.tw/i/apis/jobsearch.cfm?kws=Internet&order=1&kwop=2&fmt=8&page=1&incs=2&cols=JOB%2CNAME%2CLINK%2CLAT%2CLON%2CADDR_NO_DESCRIPT%2CADDRESS%2CDESCRIPTION'
end

def call_104_url(url)
  HTTP.get(url)
end

response = {}
results = {}


get_record_num_url = get_total_record_num_path
response[get_record_num_url] = call_104_url(get_record_num_url)
record_num = JSON.parse(response[get_record_num_url].body)
results['RECORDCOUNT'] = record_num
results['PAGECOUNT'] = (record_num + 19) / 20


url = api_path(1)
response[url] = call_104_url(url)
# results['size'] = response[url]["RECORDCOUNT"]
contents = JSON.parse(response[url].body)
results['size'] = contents['PAGECOUNT']
results['page'] = contents['PAGE']
results['contents'] = contents['data']


File.write('spec/fixtures/response.yml', response.to_yaml)
File.write('spec/fixtures/results.yml', results.to_yaml)