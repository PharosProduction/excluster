{application,pobox,
             [{description,"External buffer processes to protect against mailbox overflow"},
              {vsn,"1.2.0"},
              {applications,[stdlib,kernel]},
              {registered,[]},
              {modules,[pobox,pobox_buf,pobox_queue_buf]},
              {maintainers,["Fred Hebert"]},
              {licenses,["MIT"]},
              {links,[{"Github","https://github.com/ferd/pobox/"}]}]}.
