class webhook {
  include golang
  golang::get{'github.com/droyo/webhook':}
}
