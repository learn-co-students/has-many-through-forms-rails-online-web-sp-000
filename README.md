# Has Many Through Forms Rails

## Objectives

1. construct a bi-directional has many through.
2. identify the join model in a has many through.
3. Construct a nested params hash with data about the primary object and a has many through association.
4. Use the conventional key names for associated data (assoication_attributes).
5. Name form inputs correctly to create a nested params hash with has many through association data.
6. Define a conventional association writer for the primary model to properly instantiated associations based on the nested params association data.
7. Define a custom association writer for the primary model to properly instantiated associations with custom logic (like unique by name) on the nested params association data.
8. Use fields_for to generate the association fields.

## Overview

We've looked at the different ways we can interact with our associations through forms, as well as displaying data from more complex associations. In this lesson, we'll look at some different ways we can create data from our complex associations to make for a great user experience.

## accepts_nested_attribues for through relationships

Let's go back to our blog example - a post can have many categories, and a category can have many posts. How can we set this up? Yep, we'll need a join table. In this case, we'll call it "PostCategory"

```ruby
#app/models/post.rb
class Post < ActiveRecord::Base
  has_many :post_categories
  has_many :categories, through: :post_categories
end
```

```ruby
#app/models/category.rb
class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories
end

```

```ruby
#app/models/post_category.rb
class PostCategory < ActiveRecord::Base
  belongs_to :post
  belongs_to :category
end
```

Now, let's make it so that our user can assign categories to a post when the post is created. When there was no join table and our post was directly related to it's category, it responded to a method called `category_ids=` that we were able to use to associate our models.

Luckily, `has_many, through` functions exactly the same as a has_many relationship. Instances of our `Post` class still respond to a method called `category_ids=`. This means that we can use all of the same helper methods to generate our form.

```erb
#app/views/posts/_form.html.erb
<%= form_for post do |f| %>
  <%= f.label "Title" %>
  <%= f.text_field :title %>
  <%= f.label "Content" %>
  <%= f.text_area :content %>
  <%= f.collection_check_boxes :category_ids, Category.all, :id, :name %>
  <%= f.submit %>
<% end %>
```

This will generate a checkbox field for each Category in our database.

```html
<input type="checkbox" value="1" name="post[category_ids][]" id="post_category_ids_1">
```

In our controller, we've setup our `post_params` to expect an array. After submitting the form, we end up with `post_params` that look something like:

```ruby
{"title"=>"New Post", "content"=>"Some great content!!", "category_ids"=>["2", "3", ""]}
```

Let's check out the SQL that fires from creating our new post.

```SQL
INSERT INTO "posts" ("title", "content", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "New Post"], ["content", "Some great content!!"], ["created_at", "2016-01-15 21:25:59.963430"], ["updated_at", "2016-01-15 21:25:59.963430"]]

INSERT INTO "post_categories" ("category_id", "post_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["category_id", 2], ["post_id", 6], ["created_at", "2016-01-15 21:25:59.966654"], ["updated_at", "2016-01-15 21:25:59.966654"]]

INSERT INTO "post_categories" ("category_id", "post_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["category_id", 3], ["post_id", 6], ["created_at", "2016-01-15 21:25:59.968301"], ["updated_at", "2016-01-15 21:25:59.968301"]]
```
This functions just like it did with a has many relationship, but instead of creating a new record in our categories table, Active Record is creating two new rows in our `post_categories` table. This means that we can interact with our higher-level models directly without having to think too much at all about our join table - ActiveRecord will manage that relationship for us behind the scenes.


```ruby
#app/controllers/post_controller.rb
class PostsController < ApplicationController
  # ...

  private
  def post_params
    params.require(:post).permit(:title, :content, category_ids:[])
  end
```

Now, let's check out what

## Join Model Forms

Sometimes, it may be appropriate for a user to create an instance of our join model directly. Think back to the hospital domain from our previous lab. It makes perfect sense that a user would go to `appointments/new` and fill out a form to create a new appointment.

```erb
<%= form_form @appointment do |f| %>
  <%= f.datetime_select :appointment_datetime %>
  <%= f.collection_select :doctor, Doctor.all, :id, :name %>
  <%= f.collection_select :patient, Patient.all, :id, :name %>
<% end %>
```

## Outline

were going through 3 different domains here, recipes/ingredients, posts/tags, and doctors/patients and that might be confusing - I guess if we can consolidate the domain model but then still walk them through 3 implementations of a form that would create has many through data, that'd beg reat.

1. simple nested form with accepts_nested_attributes_for
  lets use this domain and form (just not using the cacoon gem, we can provide js to make it work)
  https://hackhands.com/building-has_many-model-relationship-form-cocoon/
  recipe has many quantites and ingredients

2. join model form
lets also do a doctors, patients, appointments example where the form we're going to build is actually simple and we just do appointes#new with a drop down to match patient_id and drop down to match doctor_id and an appointment_datetime field. show them that there are easy ways to interact with the join model.

3. complex nested form with custom attribute writer

domain
  post with many tags through post_tags

build out the has many through with migrations and wire up the models

post#new should display a post form that allows you to add tags via checkboxes

walk the student through generating the form and using post[tag_ids] assign existing tags to a post. this won't use fields for but it's still writing to the correct association becaues of the tag_ids= method added by has_many :tags, through

show them the sql that is run when you create a post with existing tags - how many rows, a post row and then a post_tag row for each tag.

but that doesn't work if the tag we want to add doesn't exist. how can we do that?

let's build a tags_attributes= writer that can accept tags by name. we can then use find_or_create_by to build out the tag correctly if it exists or not.

tags_attributes=(tags_attributes)
  tags_attributes.each do |tag_attributes|
    # tag_hash will look like {:name => "Tag Name"}
    self.tags.find_or_initialize_by(tag_attributes)
  end
end

that looks right but it doesn't work, we are still creating new tags instead of assigning the existing tag and only initializing a new one. show them the sql when you'd call save that a new tag was inserted in addition to the post tag row. Tagging a post is not creating a Tag instance, it's creating a post_tag instance. we have to slow down and drop down to a lower level abstraction, instead of manipulating the tags model, we have to use the post_tag model in a more gradual manner.

tags_attributes=(tags_attributes)
  tags_attributes.each do |tag_attributes|
    tag = Tag.find_or_create_by(tag_attributes)
    self.post_tags.build(:tag => tag)
  end
end

see how that custom writer first finds the unique tag and then builds the join model instead of a tag row?

this method allows us to add whatevr custom logic we want to writing to the through relationship.

now we can use fields_for to generate fields for each existing tag and add text fields for new tags. show that.

controlelr actoin for new/create stays the same.

<a href='https://learn.co/lessons/has-many-through-forms-rails' data-visibility='hidden'>View this lesson on Learn.co</a>
