class profiles::gogive {  
  class{'gogive':
    port => 9265,
    paths => {
      '/exp/ndb' => 'git https://github.com/droyo/go.ndb',
      '/encoding/ndb' => 'git https://github.com/droyo/go.ndb',
      '/exp/soap' => 'git https://github.com/droyo/go.soap',
      '/exp/display' => 'git https://github.com/droyo/go.display',
      '/exp/gl' => 'git https://github.com/droyo/go.gl',
      '/xml' => 'git https://github.com/droyo/go-xml',
      '/cmd/gogive' => 'git https://github.com/droyo/gogive',
      '/cmd/webhook' => 'git https://github.com/droyo/webhook',
      '/retry' => 'git https://github.com/droyo/retry',
      '/net/styx' => 'git https://github.com/droyo/styx',
      '/io/tailpipe' => 'git https://github.com/droyo/tailpipe',
    },
  }
}
