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
  # @raise [Mojang::Errors::MojangError]
  # @raise [Mojang::Errors::NoSuchUserError]
  def userid(username, date = nil)
    profile_str = "https://api.mojang.com/users/profiles/minecraft/#{username}"
    # If the provided date (or 0, if not provided) does not return anything, try without any date provided at all.
    # This is necessary because for users with name history's *have* you have to provide some date (and 0 is valid),
    # while for users who do *not* have name history, giving a date (including 0) will return 204 No Content.
    # If it is *still* empty after both tries, then error.
    response = Curl.get(profile_str, { at: date.to_i }).body_str
    response = Curl.get(profile_str).body_str if response.empty?
    fail Mojang::Errors::NoSuchUserError.new(username) if response.empty?
    json = Oj.load(response)
    if json.key?('error')
      fail Mojang::Errors::MojangError.new(json['error'], json['errorMessage'])
    end

    json['id']
  end

  # Gets a user's name history from their UUID.
  # @param uuid [String] The user's ID (see #{userid}).
  # @return [Hash<Symbol/Time, String>] A hash of all the names. Key is either :original, or the Time object of when
  # the name was changed. Value is always the name at that point in time.
  # @raise [Mojang::Errors::MojangError]
  def name_history(uuid)
    response = Curl.get("https://api.mojang.com/user/profiles/#{uuid}/names").body_str
    json = Oj.load(response)
    if json.key?('error')
      fail Mojang::Errors::MojangError.new(json['error'], json['errorMessage'])
    end
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
end
