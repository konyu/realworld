# frozen_string_literal: true

module Types
  class ArticleType < Types::BaseObject
    field :author, UserType, null: false
    def author
      Loaders::AssociationLoader.for(Article, :author).load(object)
    end

    field :body, String, null: false
    field :comments, [CommentType], null: false

    def comments
      object.comments.order(created_at: :desc)
    end

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :description, String, null: true
    field :favorites_count, Int, null: false
    field :slug, ID, null: false
    field :tags, [TagType], null: false
    def tags
      Loaders::AssociationLoader.for(Article, :tags).load(object)
    end

    field :title, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :viewer_did_favorite, Boolean, null: false

    def viewer_did_favorite
      return false if context[:current_user].nil?

      context[:current_user].favorite_articles.include?(object)
    end

    expose_authorization_rules :favorite?, :unfavorite?, :update?, :delete?, :create?,
                               prefix: 'can_'
    expose_authorization_rules :create?, with: CommentPolicy,
                                         field_name: 'can_create_comment'
  end
end
