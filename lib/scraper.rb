require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open("#{index_url}"))
    students = []
    doc.css(".student-card").each do | card |
      name = card.css(".student-name").text
      location = card.css(".student-location").text
      profile_url = card.css("a").first["href"]
      students << {:name=>name,
                   :location=>location,
                   :profile_url=>profile_url}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open("#{profile_url}"))
    urls = doc.css(".social-icon-container a").map { |link| link["href"]}
    twitter = urls.detect { |url| url =~ /twitter/}
    linkedin = urls.detect { |url| url =~ /linkedin/}
    github = urls.detect { |url| url =~ /github/}
    profile_quote = doc.css(".profile-quote").text
    bio = doc.css(".description-holder p").text
    info = {:twitter=>twitter,
            :linkedin=>linkedin,
            :github=>github,
            :blog=>urls[3],
            :profile_quote=>profile_quote,
            :bio=>bio
            }
    info.delete_if { |k, v| v == nil}
    info
  end

end
