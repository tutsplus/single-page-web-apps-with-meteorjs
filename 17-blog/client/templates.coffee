ifViewing = (viewName) -> Session.get('currentView') is viewName

Template.main.events
    'click a[href^="/"]' : (e, t) -> 
        Backbone.history.navigate e.currentTarget.pathname, true
        e.preventDefault()

Template.header.adminLoggedIn = () -> adminLoggedIn()
Template.header.events
    'click button' : () -> Backbone.history.navigate '/new-post', true

Template.newPostForm.show = () -> ifViewing 'newPostForm'
Template.newPostForm.events
    'keyup #title' : (e, t) ->
        t.find("#slug").value = t.find("#title").value.toLowerCase().split(' ').join('-')
    'click button': (e, t) ->
        if adminLoggedIn()
            slug = t.find("#slug").value
            Meteor.call 'post', t.find('#content').value, 
                                t.find('#title').value, 
                                slug
                                (err, id) -> 
                                    Backbone.history.navigate '/' + slug, true

Template.posts.show = () -> ifViewing('posts') or ifViewing 'post'
Template.posts.posts = () -> 
    if ifViewing 'post'
        Posts.find { slug: Session.get 'currentPost' }
    else                
        Posts.find {}, { sort: { createdOn: -1 }}
