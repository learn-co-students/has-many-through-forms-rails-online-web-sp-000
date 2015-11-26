
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
