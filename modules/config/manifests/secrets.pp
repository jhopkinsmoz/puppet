# the keys in this file are documented in
#   https://wiki.mozilla.org/ReleaseEngineering/PuppetAgain#Secrets
# if you add a new key here, add it to the wiki as well!
class config::secrets {
    $root_pw_hash = extlookup("root_pw_hash")
    $builder_pw_hash = extlookup("builder_pw_hash")
}
