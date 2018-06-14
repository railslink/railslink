class MembershipSubmissionsController < ApplicationController
  def new
    @submission = SlackMembershipSubmission.new
  end

  def create
    redirect_to root_path and return if submission_params.key?(:fax)

    @submission = SlackMembershipSubmission.new(submission_params)

    if @submission.save
      flash[:info] = "Thanks! Look for an email from us in the next couple of days."
      redirect_to root_path
      return
    end

    flash[:danger] = "There were problems with your submission. Please try again."
    render action: :new
  end

  private

  def submission_params
    params.require(:slack_membership_submission).
      permit(:first_name, :last_name, :email, :location, 
             :website_url, :github_url, :linkedin_url, :introduction, :fax)
  end
end
