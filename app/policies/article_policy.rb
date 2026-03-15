class ArticlePolicy < ApplicationPolicy
  def create?
    user.editor_or_admin?
  end

  def update?
    user.admin? || record.author == user
  end

  def destroy?
    user.admin? || record.author == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.published
      end
    end
  end
end
