require 'flickr'

class StaticPagesController < ApplicationController
  def index
    flickr_id = params[:flickr_id]
    return if flickr_id.blank?

    flickr = Flickr.new
    2.times do
      @user = flickr.profile.getProfile(user_id: flickr_id)
      break
    rescue Flickr::FailedResponse => e
      flickr_id = flickr.people.findByUsername(username: flickr_id).nsid
    end
    public_photos = flickr.people.getPublicPhotos(user_id: flickr_id, per_page: 5)
    @feed = []
    public_photos.each do |photo|
      info = flickr.photos.getInfo(photo_id: photo.id)
      @feed << Flickr.url_n(info)
    end
  end
end
