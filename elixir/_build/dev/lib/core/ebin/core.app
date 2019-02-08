{application,core,
             [{applications,[kernel,stdlib,elixir,sasl,logger,runtime_tools,
                             observer,wx,gen_leader,gproc,nodefinder,
                             prometheus,prometheus_ex,horde,pobox,
                             prometheus_httpd,nebulex,toml,prometheus_plugs]},
              {description,"core"},
              {modules,['Elixir.Core','Elixir.Core.ActionServer',
                        'Elixir.Core.Application','Elixir.Core.Counters',
                        'Elixir.Core.GlobalCache','Elixir.Core.Net',
                        'Elixir.Core.OtpServer','Elixir.Core.OtpSupervisor',
                        'Elixir.Core.StateHandoff','Elixir.Core.StoreServer',
                        'Elixir.Core.UserServer',
                        'Elixir.Core.UserSupervisor']},
              {vsn,"1.0.0"},
              {mod,{'Elixir.Core.Application',[]}},
              {registered,['Elixir.Excluster.Core']},
              {env,[]}]}.