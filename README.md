# Features
- wechat omniauth only login
- requires phone and email to login the system
- phone confirmation service
- I18n internationalization (default locale is zh-CN)
- rpsec test and simplecov test coverage (97.2% LOC covered)
    - config the required configuration
    - run `rspec`
    - open `index.html` inside the `coverage` folder

# Resources
- [wechat starter](https://github.com/goofansu/wechat-starter)
- [yunpian](https://www.yunpian.com) sms sending services
- [devise](https://github.com/plataformatec/devise) authentication system

# (Required) Configuration
1. `config/application.yml`
    
    **Required fields**:
    - wechat_app_id
    - wechat_secret
    - wechat_token
    - yunpian_apikey *( ignore this field if you don't 
        want use yunpian sms service )* 

    **Option fields**:

    > Ignore the following two fileds if your are testing the service on wechat
     [test account](http://mp.weixin.qq.com/debug/cgi-bin/sandbox?t=sandbox/login), 
     only set it when you are in production. 

    - wechat_encrypt_mode 
    - wechat_encoding_aes_key

2. `config/menu_{environemnt}.yaml`

    **Required fields**:
    - `main->url` *( set the url to your hosting server url )*
    - `signin->url` *( set the url to your hosting server url )*

# (Option) Configuration
- **I18n**

    The default locale for this project is `zh-CN`, if you want to change the
     default locale you can go the `config/application.rb` and change the line  
     `config.i18n.default_locale = 'zh-CN'` to other locale. In addition, you 
     need to add the corresponding locale file inside the `config/locales` folder.

- **Database name**

    Change the database name inside the `config/database.yml` file

- **Wechat public account menu**

    Change the `config/menu_{environemnt}.yaml` file to customize the wechat 
    public account menu. Run `rake wechat:menu_create` to push the menu to 
    wechat public accout.