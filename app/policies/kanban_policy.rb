class KanbanPolicy < ApplicationPolicy
  def index?
    @account_user.administrator? || @account_user.worker?
  end

  def update?
    @account_user.administrator?
  end

  def list_attributes?
    true
  end

  def list_cards?
    index?
  end

  def update_card?
    index?
  end

  def update_attributes?
    @account_user.administrator?
  end

  def show?
    index?
  end

  def create?
    @account_user.administrator?
  end

  def destroy?
    @account_user.administrator?
  end
end
