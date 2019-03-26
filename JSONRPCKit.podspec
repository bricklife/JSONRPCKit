Pod::Spec.new do |s|
  s.name     = 'JSONRPCKit'
  s.version  = '4.1.0'
  s.summary  = 'JSONRPCKit is a JSON-RPC 2.0 library purely written in Swift.'
  s.homepage = 'https://github.com/ollitapa/JSONRPCKit'

  s.authors = {
    'Shinichiro Oba' => 'ooba@bricklife.com',
    'Olli Tapaninen' => 'ollitapa@gmail.com'
  }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.swift_version = '5.0'
  s.source_files = 'Sources/JSONRPCKit/*.{swift,h,m}'
  s.source = {
    git: 'https://github.com/ollitapa/JSONRPCKit.git',
    tag: s.version.to_s
  }

  s.license = {
    type: 'MIT',
    text: <<-LICENSE
      Copyright (c) 2015-2017 Shinichiro Oba, 2018-2019 Olli Tapaninen
      Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
      The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    LICENSE
  }
end
