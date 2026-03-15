module Api
  module Reports
    class PopularController < BaseController
      skip_before_action :authenticate_user!

      def popular
        from = parse_date(params[:from])&.beginning_of_day || 30.days.ago
        to   = parse_date(params[:to])&.end_of_day         || Time.current

        articles = Article.published
                          .joins(:view_logs)
                          .where(view_logs: { created_at: from..to })
                          .group("articles.id")
                          .order("COUNT(view_logs.id) DESC")
                          .limit(10)
                          .select("articles.*, COUNT(view_logs.id) AS period_views")

        render json: {
          data: articles.map { |a|
            { id: a.id, title: a.title, views_count: a.views_count,
              period_views: a.period_views.to_i }
          },
          meta: { from: from, to: to }
        }
      end
      private

      def parse_date(value)
        return nil if value.blank?

        Date.parse(value)
      rescue ArgumentError
        render json: { error: "Неверный формат даты, используйте YYYY-MM-DD" }, status: :bad_request
        nil
      end
    end
  end
end
