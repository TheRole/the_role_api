### `User` **has only one** `Role`

My practice showed, using of many roles for one user is very, very bad approach. In reality, Usually, no one needs it.

Many roles for one user is a reason of many logical mistakes. Calculation of permitted actions for user becomes difficult.

It's difficult to imagine how to create simple and usable interface to manage and to control roles for a user.

TheRole provide only one role for one user. It's most simple, logical and effective approach.

### Only `User` model supported

Right now TheRole works only with model `User`.
You can't use it with `Account`, `Manager`, `Employer` etc.

You can improve TheRole with beauty patch.
If it be really great, I'll add this feature into The Role.

### Based on `curent_user` method

`curent_user` is a most popular name of method associated with logged user. TheRole uses it by default.
There is no ways to use something else. Sorry.

### Role stored in database as a JSON String

There are many databases which provide special native ways to work with JSON data.
But TheRole convert hashes into JSON string and store it into database with plain TEXT value.
TheRole uses this approach because it requires less of code. And it makes maintaining simpler.
