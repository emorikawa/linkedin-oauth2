module LinkedIn
  class MashMiddleware < ::Faraday::Response::Middleware
    def call(env)
      @app.call(env).on_complete do
        env.body = Mash.from_json(env.body)
        p env.body.class
      end
    end
  end
end
