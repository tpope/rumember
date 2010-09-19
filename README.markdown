Rumember
========

Ruby API and command line client for [Remember The
Milk](http://www.rememberthemilk.com/).

## Command line usage

The sole motivation for this project was a quick way to capture to-dos
from the command line.  As such, I've chosen a chosen a very short
command name of `ru` (something I'd normally never allow myself to do).
All arguments are joined with spaces and used to invoke Remember The
Milk's [Smart Add](http://www.rememberthemilk.com/services/smartadd/)
feature.

    ru buy milk #errand

Browser based authentication is triggered the first time `ru` is run,
and the resulting token is cached in `~/.rtm.yml`.

I was originally planning to add support for the full range of
operations possible in Remember The Milk, but after pondering the
interface, this seems unlikely.  I just can't imagine myself forgoing
the web interface in favor of something like:

    ru --complete 142857 # Ain't gonna happen

## API Usage

The API is a bit more fleshed out than the command line interface, but
still incomplete, under-documented, and under-tested (I have additional
integration tests I won't publish because they are specific to my RTM
account).  You'll need to familiarize yourself with [Remember The Milk's
API](http://www.rememberthemilk.com/services/api/).  In particular, you
need to understand what a timeline is.

    interface = Rumember.new(api_key, shared_secret)
    interface = Rumember.new # Uses built in credentials
    interface.dispatch('test.echo')

    account = interface.account(auth_token)
    account = interface.account # browser based and cached
    account = Rumember.account # Rumember.new.account shortcut

    timeline = account.timeline # cached
    timeline = account.new_timeline # fresh each time

    timeline.smart_add('buy milk #errand')

    list = timeline.lists.first
    task = list.tasks.first
    transaction = task.complete
    transaction.undo

## Contributing

Please follow [Git commit message best
practices](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
when submitting a pull request.
