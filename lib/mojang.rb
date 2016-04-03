require 'curb'
require 'oj'
require_relative 'errors'

# Wrapper module around the Mojang and Minecraft web APIs.
module Mojang
  module_function

  # Gets the status for the various Mojang and Minecraft servers and web services.
  # @return [Hash<String, String>] A hash containing keys of the sites, and values of the statuses (green, yellow, red).
  def status
    response = Curl.get('https://status.mojang.com/check'.freeze).body_str
    json = Oj.load(response)
    ret = {}
    # Reformatting the returned data because it is super annoying to work with.
    json.each do |hash|
      hash.each do |site, status|
        ret[site] = status
      end
    end

    ret
  end

  # Gets the User ID (UUID) for the given username at the given time.
  # @param username [String] The username.
  # @param date [Date] The date to get the ID at.
  # @return [String] The username's user ID.
  def userid(username, date = nil)
    self.profile(username, date, 'id')
  end

  # Gets the username for the given UUID at the given time.
  # @param uuid [String] The user's UUID (see #{userid})
  # @param date [Date] The date to get the name at.
  # @return [String] The user's username at the given time.
  def username(uuid, date = nil)
    self.profile(uuid, date, 'name')
  end

  # Gets whether the given username has paid for Minecraft.
  # @param username [String] The username to check.
  # @return [Boolean] Whether they have paid or not.
  def has_paid?(username)
    params = { user: username }
    response = Curl.get('https://minecraft.net/haspaid.jsp', params).body_str

    response == 'true'
  end

  # Gets a user's name history from their UUID.
  # @param uuid [String] The user's ID (see #{userid}).
  # @return [Hash<Symbol/Time, String>] A hash of all the names. Key is either :original, or the Time object of when
  # the name was changed. Value is always the name at that point in time.
  def name_history(uuid)
    response = Curl.get("https://api.mojang.com/user/profiles/#{uuid}/names").body_str
    json = Oj.load(response)
    ret = {}
    json.each do |hash|
      if hash.key?('changedToAt')
        ret[Time.at(hash['changedToAt'] / 1000)] = hash['name']
      else
        ret[:original] = hash['name']
      end
    end

    ret
  end

  private

  # Gets the profile data.
  # @param query [String] Either a username or an ID; they are handled in the same way.
  # @param date [Date] The date to get at.
  # @param return_val [String] The key in the returned hash to return.
  # @return [String] The returned value for the return_val key.
  def self.profile(query, date, return_val)
    params = { at: date.to_i }
    response = Curl.get("https://api.mojang.com/users/profiles/minecraft/#{query}", params).body_str
    fail NoSuchUserError.new(query) if response.empty?
    json = Oj.load(response)
    if json.key?('error')
      fail MojangError.new(json['error'], json['errorMessage'])
    end
    return json[return_val]
  end
end
