# Posts

From a high level point of view the demo consists of a list of posts, where each post has its own detail.

Posts Screen

A post has a title. To retrieve the posts, I use the following:

http://jsonplaceholder.typicode.com/posts
When a post is tapped, you go to the detail screen.

Detail screen

A post detail screee has:

Its author.
Its description (via the body).
Number of comments it has.
It retrieves the remaining information from:

http://jsonplaceholder.typicode.com/users
http://jsonplaceholder.typicode.com/comments

The information (posts and post details) are available offline. It's assumed that if it's the first time you are accessing the app, and you are offline, you shouldn't see anything.

# Instalation

In order for the project to compile you'll to have Carthage installed in your machine. With Carthage installed you can clone the project and inside the project folder run:
```
carthage update --platform iOS
```
Then just opening the iOS project file as normal.
