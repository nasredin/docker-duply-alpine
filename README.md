alpine version of https://github.com/kurthuwig/docker-duply


google drive how-to:
https://blog.xmatthias.com/duplicity-google-drive/


/root/pydrive.conf

client_config_backend: settings
client_config:
client_id: ###
client_secret: ###
save_credentials: True
save_credentials_backend: file
save_credentials_file: /root/pydrivecreds.json
get_refresh_token: True


