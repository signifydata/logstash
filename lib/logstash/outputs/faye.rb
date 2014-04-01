require "logstash/namespace"
require "logstash/outputs/base"

# File output.
#
# Write events to files on disk. You can use fields from the
# event as parts of the filename.
class LogStash::Outputs::Faye < LogStash::Outputs::Base

  config_name "faye"
  milestone 1

  config :channel, :validate => :string

  config :faye_token, :validate => :string

  config :faye_url, :validate => :string, :default => "http://localhost:9292/faye"

  public
  def register
    require "net/http"
  end # def register

  public
  def receive(event)
    return unless output?(event)

  _send_message event
  end # def receive

  private
  def _send_message(data)
    if @faye_token
      message = {:channel => @channel, :data => data, :ext => {:auth_token => @faye_token}}
    else
      message = {:channel => @channel, :data => data}
    end

    uri = URI.parse(@faye_url)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def teardown
    finished
  end
end # class LogStash::Outputs::File


