class Admin::MembershipSubmissionsController < AdminController
  def pending
    @num_pending = SlackMembershipSubmission.pending.count

    if @num_pending.zero?
      flash[:info] = "There are no pending submissions right now."
      redirect_to admin_path
      return
    end

    @submission = SlackMembershipSubmission.pending.chronologically.first
  end

  def approve
    submission = SlackMembershipSubmission.find_by(id: params[:id])

    if submission.pending?
      if submission.approve_and_invite!
        flash[:info] = "#{submission.name} was approved and has been invited."
      else
        flash[:danger] = "Error approving #{submission.name}: #{submission.approval_error}"
      end
    else
      flash[:warning] = "#{submission.name} was previously #{submission.status}."
    end

    redirect_to pending_admin_membership_submissions_path
  end

  def reject
    submission = SlackMembershipSubmission.find_by(id: params[:id])

    if submission.pending?
      submission.rejected!
      flash[:info] = "#{submission.name} was rejected."
    else
      flash[:warning] = "#{submission.name} was previously #{submission.status}."
    end
    redirect_to pending_admin_membership_submissions_path
  end
end
