defmodule Config do
  def config do
    [webserver:
      [http_host: "localhost",
       http_port: 9913,
       acceptors: 100,
       ssl: false,
       cacertfile_path: "",
       certfile_path: "",
       keyfile_path: ""
      ],
    ws:
      [ws_port: 9913,
       ws_mod: :Handler
      ],
    use_internationalization: false,
    localization:
      [default_locale: :en_US,
       use_locales: [:en_US]
      ],
    use_sessions: false,
    session:
      [max_age: 1440
      ],
    log: true
    ]
  end
end
