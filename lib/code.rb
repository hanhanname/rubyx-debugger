include AST::Sexp
CODE = s(:expressions,
  s(:class, :Integer,
    s(:derives, :Object),
    s(:expressions,
      s(:function, :ref,
        s(:name, :add_string),
        s(:parameters,
          s(:parameter, :ref, :str)),
        s(:expressions,
          s(:field_def, :int, :div),
          s(:assign,
            s(:name, :div),
            s(:operator, "/",
              s(:name, :self),
              s(:int, 10))),
          s(:field_def, :int, :rest),
          s(:assign,
            s(:name, :rest),
            s(:operator, "-",
              s(:name, :self),
              s(:name, :div))),
          s(:if,
            s(:condition,
              s(:operator, "<",
                s(:name, :rest),
                s(:int, 0))),
            s(:if_true,
              s(:assign,
                s(:name, :str),
                s(:operator, "+",
                  s(:name, :str),
                  s(:call,
                    s(:name, :digit),
                    s(:arguments,
                      s(:name, :rest)))))),
            s(:if_false,
              s(:assign,
                s(:name, :str),
                s(:call,
                  s(:name, :add_string),
                  s(:arguments,
                    s(:name, :str)),
                  s(:receiver,
                    s(:name, :div)))))),
          s(:return,
            s(:name, :str)))),
      s(:function, :ref,
        s(:name, :to_string),
        s(:parameters),
        s(:expressions,
          s(:field_def, :ref, :start,
            s(:string, " ")),
          s(:return,
            s(:call,
              s(:name, :add_string),
              s(:arguments,
                s(:name, :start)))))))))
