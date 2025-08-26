# app/controllers/franchises_controller.rb
class FranchiseController < ApplicationController
  before_action :set_service

  # GET /franchises/customer/:customer_id
  def for_customer
    result = @service.list_franchises_for_customer(params[:customer_id])
    render json: result
  end

  def all_franchises
    # puts "Test #{pagination_params}"
    result = @service.list_franchises(pagination_params)
    render json: result
  end

  def get_franchise_profile
    result = @service.franchise_profile(params[:franchise_id])
    render json: result
  end

  def update_franchise_profile
    franchise_id = params[:franchise_id]
    body = financial_profile_params

    FranchiseService.new.update_franchise_profile(franchise_id, body)
  end

  private

  def set_service
    @service = FranchiseService.new
  end

  def pagination_params
    {
      page: (params[:page] || 1).to_i,
      per_page: (params[:perPage] || 10).to_i,
      franchise_name: params.dig(:param, :franchiseName)
    }
  end

  # def financial_profile_params
  #   params.permit(
  #     franchise: [:name, :website, :mission, :contactPerson, :phoneNumber, :franchiseId],
  #     # brandReputation: [:foundingDate, :franchiseProgramYear, :totalUnits, :growthRate, :satisfactionScore],
  #     # financialInformation: [
  #     #   :franchiseFee, :royaltyFee, :marketingFee, :softwareLicenseFee,
  #     #   :renewalFee, :trainingFee, :supplyFee, :profitMargin,
  #     #   :netWorthRequirement, :liquidityRequirement,
  #     #   { capital: [:name] }
  #     # ],
  #     # operationInformation: [:ownershipModel, :staffCountRequired, :approvedSupplierOnly, :corporateSupplierOnly]
  #   ).to_h
  # end

  def financial_profile_params
    params.permit(
      franchise: [:name, :website, :mission, :contact_person, :phone_number],
      brand_reputation: [:founding_date, :franchise_program_year, :total_units, :growth_rate, :satisfaction_score],
      financial_information: [
        :royalty_fee, :marketing_fee, :software_license_fee,
        :renewal_fee, :training_fee, :supply_fee, :profit_margin,
        :net_worth_requirement, :liquidity_requirement
      ],
      operation_information: [:ownership_model, :staff_count_requirement, :approved_supplier_only, :corporate_supplier_only]
    )
  end
  # def financial_profile_params
  #   params.permit([:name, :website, :mission, :contactPerson, :phoneNumber])
  # end

end
