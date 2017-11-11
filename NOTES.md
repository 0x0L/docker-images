# Jupyterhub image

## How to expose additional ports (eg tensorboard) ?

## LDAP support for jupyterhub

  ```sh
  conda install ldap3
  pip install git+https://github.com/jupyterhub/ldapauthenticator
  jupyterhub --generate-config
  ```

  ```python
  c.JupyterHub.authenticator_class = 'ldapauthenticator.LDAPAuthenticator'
  c.LDAPAuthenticator.server_address = 'ldap.forumsys.com'
  c.LDAPAuthenticator.bind_dn_template = [
      'uid={username},dc=example,dc=com',
  ]
  ```

## Custom jupyterhub AWS docker spawner

## User management
* creation / groups / volumes
* IPython set default Matplotlib backend to 'inline'
* IPython set Jedi completer to false
