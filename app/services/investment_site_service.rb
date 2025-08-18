# app/services/investment_site_service.rb
class InvestmentSiteService
  def initialize(params)
    @north = params[:north]
    @south = params[:south]
    @east  = params[:east]
    @west  = params[:west]
  end

  def call
    return [] unless @north && @south && @east && @west

    sites = InvestmentSite.includes(franchise: :capital).where(
      latitude:  @south..@north,
      longitude: @west..@east
    )

    sites.map do |site|
      puts "Testing -> #{site.franchise.capital.name}"
      {
        franchise: {
          id: site.franchise.id,
          name: site.franchise.name,
          capital: {
            name: site.franchise.capital.name,
          }
        },
        longitude: site.longitude,
        latitude:  site.latitude
      }
    end
  end
end
