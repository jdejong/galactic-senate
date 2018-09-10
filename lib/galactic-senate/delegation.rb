# frozen_string_literal: true

module GalacticSenate
  class Delegation

    SUPREME_CHANCELLOR_INTERVAL = 10
    SENATOR_INTERVAL = 30
    RAND_INTERVAL = 15
    KEY = "galactic-senate-supreme-chancellor"

    def initialize
      @running = true
      @supreme_chancellor_timeout = 0
    end

    def self.instance
      @galactic_senate ||= GalacticSenate::Delegation.new
    end


    def self.supreme_chancellor?
      instance.supreme_chancellor?
    end

    def supreme_chancellor?
      ( @supreme_chancellor_timeout > Time.now.to_f )
    end

    alias_method :leader?, :supreme_chancellor?
    class << self
      alias_method :leader?, :supreme_chancellor?
    end

    def debate

      vote_of_no_confidence

      timer_task = Concurrent::TimerTask.new(execution_interval: interval) do |task|

        begin
          vote_now
          task.execution_interval = interval
        rescue => e
          GalacticSenate.config.logger.error "GalacticSenate::Delegation.debate - #{e.message}"
          GalacticSenate.config.logger.error "GalacticSenate::Delegation.debate - #{e.backtrace.inspect}"
        end
      end

      timer_task.execute

    end

    def vote_now
      if supreme_chancellor?
        if update_supreme_chancellor
          @supreme_chancellor_timeout = Time.now.to_f + SENATOR_INTERVAL
        else
          @supreme_chancellor_timeout = 0
          fire_event(:ousted)
        end
      else
        vote_of_no_confidence
      end
    end

    def vote_of_no_confidence
      if elect_me_supreme_chancellor?
        @supreme_chancellor_timeout = Time.now.to_f + SENATOR_INTERVAL
        fire_event(:elected)
      else
        @supreme_chancellor_timeout = 0
      end
    end

    def fire_event(event, val = nil)
      GalacticSenate.config.events[event].each do |block|
        begin
          block.call(val)
        rescue => e
          GalacticSenate.config.logger.error "GalacticSenate::Delegation.fire_event - #{e.message}"
          GalacticSenate.config.logger.error "GalacticSenate::Delegation.fire_event - #{e.backtrace.inspect}"
        end
      end
    end

    def interval
      supreme_chancellor? ? SUPREME_CHANCELLOR_INTERVAL : SENATOR_INTERVAL
    end

    private

    def get_supreme_chancellor
      GalacticSenate.config.redis.call("get",KEY)
    end

    def delete_supreme_chancellor
      GalacticSenate.config.redis.call("del",KEY)
    end

    def expire_supreme_chancellor
      GalacticSenate.config.redis.call("expire",KEY, SENATOR_INTERVAL)
    end

    def elect_me_supreme_chancellor?
      val = GalacticSenate.config.redis.set(KEY, GalacticSenate.whoami, ex: SENATOR_INTERVAL, nx: true)
      val
    end

    def update_supreme_chancellor
      ( get_supreme_chancellor == GalacticSenate.whoami ? expire_supreme_chancellor : 0 ) != 0
    end

  end
end