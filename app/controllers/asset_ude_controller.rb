class AssetUdeController < ApplicationController
  
  def index

  end
  
  def new
    @ude_asset = McocRenewalsUdeAsset.new()
  end
  

end
