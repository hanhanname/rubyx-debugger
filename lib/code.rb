include AST::Sexp
CODE =   s(:class, :Object,
                    s(:derives, nil),
                      s(:statements,
                        s(:function, :int,
                          s(:name, :main),
                          s(:parameters),
                          s(:statements,
                            s(:call,
                              s(:name,  :putstring),
                              s(:arguments),
                              s(:receiver,
                                s(:string,  "Hello again")))))))
