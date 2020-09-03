

Pod::Spec.new do |s|
  s.name         = "XNNetwork"
  s.version      = "1.0"
  s.summary      = "犀鸟网络库"
  s.homepage     = "https://github.com/xiniaogongkao/XNNetwork-Swift.git"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "f2yu" => "470623403@qq.com" }
  s.platform      = :ios, "9.0"
  s.source       = { :git => "https://github.com/xiniaogongkao/XNNetwork-Swift.git", :tag => "1.0" }
  s.requires_arc = true
  
  s.source_files  = "XNNetwork/XNNetwork/*.swift"
  
  s.subspec 'Define' do |ss|
    ss.source_files = "XNNetwork/XNNetwork/Define/*.swift"
    ss.dependency 'Alamofire'
  end
  
  s.subspec 'Configuration' do |ss|
    ss.dependency 'XNNetwork/Define'
   
    ss.source_files = "XNNetwork/XNNetwork/Configuration/*.swift"
  end
  
  s.subspec 'Category' do |ss|
    ss.source_files = "XNNetwork/XNNetwork/Category/*.swift"
  end
  
  s.subspec 'Model' do |ss|
    ss.dependency 'XNNetwork/Define'
  
    ss.source_files = "XNNetwork/XNNetwork/Model/*.swift"
  end
  
  s.subspec 'Log' do |ss|
    ss.dependency 'XNNetwork/Model'
    ss.dependency 'XNNetwork/Category'
  
    ss.source_files = "XNNetwork/XNNetwork/Log/*.swift"
  end
  
  s.subspec 'CoreNetwork' do |ss|
    ss.subspec 'Response' do |sss|
      sss.source_files = "XNNetwork/XNNetwork/CoreNetwork/Response/*.swift"
    end
    
    ss.subspec 'NetworkAgent' do |sss|
      sss.dependency 'XNNetwork/CoreNetwork/Response'
      sss.dependency 'XNNetwork/Configuration'
      sss.dependency 'Alamofire'
      
      sss.source_files = "XNNetwork/XNNetwork/CoreNetwork/NetworkAgent/*.swift"
    end
    
    ss.subspec 'Request' do |sss|
      sss.dependency 'XNNetwork/CoreNetwork/Response'
      sss.dependency 'XNNetwork/CoreNetwork/NetworkAgent'
      sss.dependency 'XNNetwork/Configuration'
      sss.dependency 'XNNetwork/Model'
      sss.dependency 'XNNetwork/Define'
      sss.dependency 'XNNetwork/Log'
      sss.dependency 'Alamofire'
    
      sss.source_files = "XNNetwork/XNNetwork/CoreNetwork/Request/*.swift"
    end
  end
  
  s.subspec 'APIManager' do |ss|
    ss.dependency 'XNNetwork/CoreNetwork/Request'
  
    ss.source_files = "XNNetwork/XNNetwork/APIManager/*.swift"
  end
  
end
