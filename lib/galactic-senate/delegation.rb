# frozen_string_literal: true

module GalacticSenate
  class Delegation

    SUPREME_CHANCELLOR_INTERVAL = 10
    SENATOR_INTERVAL = 30
    RAND_INTERVAL = 15
    KEY = "galactic-senate-supreme-chancellor"

    def initialize
      @running = true
    end

    def self.instance
      @galactic_senate ||= GalacticSenate::Delegation.new
    end

    singleton_class.send(:alias_method, :leader?, :supreme_chancellor?)

    def self.supreme_chancellor?
      instance.supreme_chancellor?
    end

    def debate
      vote_of_no_confidence

      sleep(interval + rand(RAND_INTERVAL)) unless supreme_chancellor?

      timer_task = Concurrent::TimerTask.new(execution_interval: interval) do |task|

        begin
          vote_now
          task.execution_interval = self.interval
        rescue => e

        end
      end

      timer_task.execute

    end

    def vote_now
      if supreme_chancellor?
        update_supreme_chancellor
      else
        vote_of_no_confidence
      end
    end

    def vote_of_no_confidence
      elect_me_supreme_chancellor?
    end

    private

    def get_leader
      GalacticSenate.config.redis.call("get",KEY)
    end

    def delete_leader
      GalacticSenate.config.redis.call("del",KEY)
    end

    def expire_leader
      GalacticSenate.config.redis.call("expire",KEY, SENATOR_INTERVAL)
    end

    def elect_me_supreme_chancellor?
      GalacticSenate.config.redis.set(KEY, GalacticSenate.whoami, ex: SENATOR_INTERVAL, nx: true)
    end

    def update_supreme_chancellor
      ( get_leader == GalacticSenate.whoami ? delete_leader : 0 ) != 0
    end

    def interval
      supreme_chancellor? ? SUPREME_CHANCELLOR_INTERVAL : SENATOR_INTERVAL
    end

  end
end