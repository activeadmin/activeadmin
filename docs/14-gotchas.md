#Gotchas

## Session Commits & Asset Pipeline

When configuring the asset pipeline ensure that the asset prefix 
(`config.assets.prefix`) is not the same as the namespace of ActiveAdmin 
(default namespace is `/admin`). If they are the same Sprockets will prevent the 
session from being committed. Flash messages won't work and you will be unable to 
use the session for storing anything.

For more information see the following post: 
[http://www.intridea.com/blog/2013/3/20/rails-assets-prefix-may-disable-your-session](http://www.intridea.com/blog/2013/3/20/rails-assets-prefix-may-disable-your-session)