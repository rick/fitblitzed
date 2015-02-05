# fitblitzed

(experimental) tool to "earn" and track (untappd data) beers via meditation
(insight timer data) and exercise activity (fitbit data)

### Backstory

So I realized at one point that, left to my own devices, I'd avail myself of
social opportunities and drink like 300 beers in a week, or something.  At one
point I did look down and found myself thinking "pretty sure my 'winter coat'
is just stored beer energy".  This was at a point when I'd not been exercising
a lot, etc. There were other downsides too: money spent, time spent drinking
beers when I would have been fine doing something else.

So I decided to try an experiment.  

Some background... First off, [I have a treadmill desk (actually, two of
them)](https://github.com/rick/rick.github.io/tree/master/treadmill_desk), so I
have the means to get the exercise. I also have a [fitbit](http://fitbit.com/)
so I can track how many steps I take, etc. (and I wear it all the time).  I
have an account on [untappd](http://untappd.com/) and the phone app, so it's
possible for me to record when I drink a beer.

I could:

 - Set up a system whereby I promote being active.
 - Tie drinking beer to that activity incentive.
 - Basically force a "budgeting" mentality on social beering.

My idea is this:

 - For every day when I clock 10,000 steps on the fitbit, I earn 1 beer.
 - For every day when I clock 17,500 steps on the fitbit, I earn 2 beers.
 - " " 22,000 steps " ", 3 beers.
 - Call those "beer tokens".
 - If I have a beer token I'm allowed to spend it on a beer.
 - If I don't have a token I'm not allowed to drink a beer.
 - When I drink a beer I record it in untappd.

I actually have another set of rules which come from the fact that I'm a
meditator and I want to continue to promote meditating daily (and drinking lots
of beer appears to interfere with that):

 - Record all meditation sits in [Insight Timer](http://insighttimer.com/) (I have already been doing this for a number of years now).
 - If I have not already sat for 1 hour today, I cannot have a beer.

Now, obviously, all of this data management is automatable -- untappd has an
API, fitbit has an API, and, well, Insight Timer has a horrible website and no
real API, but I can screen-scrape.

So this repo is me cobbling together code to see if this is workable.

#### Other thoughts

 - It would be pretty easy to adjust the various constants, obviously
 - I plan on starting with "beer tokens never expire", but if things go well I would like to make tokens expire after, say, 1 month.

#### Issues

 - Time zones and stuff -- what do you mean by "today"? (this is especially true for Insight Timer, which has really crappy notions of "today", and if I travel things like "consecutive days" can easily get screwed up)
 - Why not just drink whiskey?  Haha. The point is to actually promote those things above. But I like whiskey just fine, so I'll probably ultimately need a way other than (just) untappd to be able to record that I had a drink of something.
 - Is it just number of steps? Well, that's fine for now. Other health proxies could be measured later.
 - I've also been thinking about a hard limit to the number of beers in a given night, as, at my age, a hangover can waste more than just the following morning. We'll see if the budgeting mentality helps take care of this or not.
 - Your algorithm might change over time.  Yep, it might. Probably the most straightforward thing would be to implement the various constants and time bounds (and perhaps even strategies) via a policy object that has time interval applicability. That may mean that we introduce state onto a token ("used" or not), instead of being purely functionally computable. Not sure. YAGNI.
