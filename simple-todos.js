Tasks = new Mongo.Collection("tasks");

if (Meteor.isClient) {
    Template.body.helpers({
        tasks: function () {
            return Tasks.find({}, {sort: {createdAt: -1}});
        }
    });

    Template.body.events({
        "submit .new-task": function (event) {
            // prevent default browser form submit
            event.preventDefault();

            // get valut from form element
            var text = event.target.text.value;

            // insert a task into the collection
            Tasks.insert({
                text: text,
                createdAt: new Date()
            });

            // clear form
            event.target.text.value = "";
        }
    });
}
