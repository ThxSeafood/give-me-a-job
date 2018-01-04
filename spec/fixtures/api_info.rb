require 'http'
require 'yaml'
require 'json'

# config = YAML.safe_load(File.read('config/secrets.yml'))

def api_path(keywords)
  'http://www.104.com.tw/i/apis/jobsearch.cfm?kws=' + keywords +'&order=1'+'&kwop=2'+'&fmt=8'+'&pgsz=200'+'&page=1'+'&incs=2'+'&cols=JOB%2CNAME%2CLINK%2CLAT%2CLON%2CADDR_NO_DESCRIPT%2CADDRESS'
end

def call_104_url(url)
  HTTP.get(url)
end

response = {}
results = {}

url = api_path('Internet')
response[url] = call_104_url(url)

# results['size'] = response[url]["RECORDCOUNT"]
contents = JSON.parse(response[url].body)

results['size'] = contents['PAGECOUNT']
results['contents'] = contents['data']

File.write('spec/fixtures/response.yml', response.to_yaml)
File.write('spec/fixtures/results.yml', results.to_yaml)