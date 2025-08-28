# Product Planning Meeting - RetailFlow MVP
**Date:** January 20, 2025  
**Attendees:** Product Team, Engineering Team, Sales (Sarah)  
**Duration:** 90 minutes

## Meeting Transcript

**Sarah (Sales):** Okay everyone, thanks for joining. We just had our follow-up demo with RetailFlow yesterday. They're really excited but need to see a working prototype by mid-February. Mike specifically wants to see the multi-location sync working with their POS.

**Alex (Product):** What POS are they using again?

**Sarah:** They have NCR Counterpoint from 2015. Old but they're not changing it. That's non-negotiable.

**Jordan (Engineering):** I looked into NCR Counterpoint. They have a REST API but it's poorly documented. We'll need to reverse engineer some endpoints. I estimate maybe 2-3 weeks just for that integration.

**Alex:** That's tight. What are the absolute must-haves for the prototype?

**Sarah:** From my notes: Real-time inventory sync across locations, mobile barcode scanning, and low stock alerts. Mike keeps talking about that $50K monthly loss. If we can show we prevent even one stockout, we're golden.

**Jordan:** Real-time is challenging with NCR. Their API has rate limits - 100 calls per minute. With 8 stores, that means we can only update every 5-6 seconds per store realistically.

**Alex:** That should be fine. Let's call it "near real-time" - under 30 seconds for full sync.

**Casey (Engineering):** For mobile, are we doing native or React Native? Native would be better for barcode scanning performance.

**Alex:** Let's go React Native for speed. We can optimize later. Jordan, can you handle the POS integration while Casey does mobile?

**Jordan:** Sure, but I'll need help with the sync algorithm. If a sale happens in Store A while Store B is transferring inventory to Store A, we need conflict resolution.

**Alex:** Good point. Let's use event sourcing. Every action is an event with a timestamp. We can replay events to resolve conflicts.

**Sarah:** They also mentioned role-based access. Store managers can transfer inventory but floor staff can only scan.

**Casey:** That's straightforward. We'll need an admin portal though. Who's building that?

**Alex:** Let's keep the admin super simple for MVP. Just user management and basic settings. Morgan, can you take that?

**Morgan (Engineering):** Yeah, I can knock out a basic admin in a few days using our standard React template. I'll need the auth system first though.

**Jordan:** I'll set up Auth0. We used it on the last project, I can copy most of the config.

**Alex:** What about the alerting system? That seems critical for their use case.

**Casey:** I'm thinking push notifications for mobile and email for managers. We could use SendGrid for email and Firebase for push.

**Sarah:** They want SMS too. Jennifer mentioned their store managers don't check email during shifts.

**Alex:** SMS gets expensive. What if we start with push and email, then add SMS in Phase 2?

**Sarah:** I can sell that if we position SMS as a premium feature.

**Jordan:** What about reporting? They'll want to see the value we're delivering.

**Alex:** Basic analytics dashboard. Just show prevented stockouts, transfer frequency, and time saved. Morgan, can you add that to the admin?

**Morgan:** If you keep it to 3-4 charts, sure. Don't ask for anything complex though.

**Casey:** I'm worried about the barcode scanning performance. The built-in React Native camera can be slow.

**Jordan:** There's a library called react-native-camera-kit that's much faster. I used it last year.

**Casey:** Perfect. I'll use that.

**Alex:** Let's talk about the sync architecture. Jordan, what are you thinking?

**Jordan:** PostgreSQL for the main database, Redis for caching, and a message queue for sync events. Probably RabbitMQ.

**Casey:** Isn't that overkill for MVP? What about just Postgres with web sockets for real-time?

**Jordan:** Web sockets could work. Simpler deployment too.

**Alex:** Let's go with Casey's approach for MVP. We can add the message queue later if needed.

**Sarah:** Quick question - they asked about offline capability. What happens if a store's internet goes down?

**Casey:** The mobile app can work offline and sync when connection returns. We'll use local SQLite.

**Jordan:** But the POS integration will break if they're offline.

**Alex:** That's fine. We'll gracefully degrade. Show cached data with a "last updated" timestamp.

**Sarah:** They also want to pilot with just 2 stores first. Can we limit the rollout?

**Alex:** Sure, we'll use feature flags. LaunchDarkly makes this easy.

**Jordan:** Speaking of deployment, are we using AWS or Google Cloud?

**Alex:** AWS. We have credits and the team knows it better. ECS for the backend, S3 and CloudFront for the frontend.

**Morgan:** Don't forget about monitoring. They had a security breach before, they'll ask about this.

**Jordan:** Datadog for monitoring, Sentry for error tracking. Standard stack.

**Alex:** Good. What about the data model? How are we handling multi-location inventory?

**Jordan:** Each SKU has a location_inventory table with quantity, reorder point, and last_updated. Transfers are tracked in an inventory_movement table.

**Casey:** We need to handle partial transfers too. Sometimes they'll only send 5 out of 10 units.

**Jordan:** Already thought of that. Transfer requests vs actual transfers are separate.

**Alex:** Smart. Okay, let's talk timeline. We have 3.5 weeks until the prototype demo.

**Sarah:** Actually, can we show them something in 2 weeks? Even if it's rough? Mike is getting pressure from his CFO.

**Alex:** Two weeks for a working prototype is aggressive.

**Jordan:** I can have basic POS integration in a week if I focus only on inventory reads, no writes yet.

**Casey:** I can get barcode scanning working in 3 days, but the UI will be rough.

**Morgan:** Basic auth and user management in 2 days.

**Alex:** Okay, let's do a staged demo. Week 2: Show basic sync and scanning. Week 4: Full prototype with alerts and transfers.

**Sarah:** That works. They'll love seeing progress.

**Casey:** One thing - we need to test with real barcode scanners, not just phone cameras. They use industrial scanners in the warehouse.

**Jordan:** Those usually emulate keyboards. Should be straightforward to support.

**Alex:** Add it to the backlog but not for MVP.

**Sarah:** Oh, I forgot - they want to see an ROI calculator in the app. Shows how much they're saving.

**Alex:** That's Product Marketing's job, not Engineering.

**Sarah:** But if it's in the app, they'll see it every day. Helps with renewal.

**Morgan:** I can add a simple calculator. Input your average stockout cost, we'll track prevented stockouts, multiply. Done.

**Alex:** Fine, but keep it simple.

**Jordan:** What about data migration? They have 2 years of inventory history in Excel.

**Alex:** Phase 2. For MVP, they start fresh.

**Sarah:** They won't like that.

**Alex:** We'll import current inventory levels but not history. Compromise?

**Sarah:** I can sell that.

**Casey:** Last concern - the app store approval process takes 1-2 weeks.

**Alex:** For the prototype, we'll use TestFlight and sideloading. Production can wait.

**Jordan:** Smart. What about API rate limits? If all 8 stores are scanning simultaneously...

**Alex:** Good point. We need request queuing and batching.

**Jordan:** I'll implement exponential backoff too. Don't want to get blocked by NCR.

**Alex:** Alright, let's wrap up. Everyone clear on priorities?

**Team:** Yes.

**Alex:** Jordan, you're on POS integration and backend. Casey, mobile app and scanning. Morgan, admin portal and auth. I'll handle deploy pipeline and coordinate. Sarah, keep RetailFlow warm and manage expectations.

**Sarah:** When can we show them the API docs? Jennifer wants to review.

**Jordan:** Give me 3 days. I'll use Swagger.

**Alex:** Perfect. Daily standups at 9am. We'll do a internal review Friday to see where we are. Any blockers, raise them immediately. This is our biggest deal this quarter, let's nail it.

**Casey:** What about testing? We haven't talked about that.

**Alex:** Unit tests for critical paths only. We'll add integration tests after we close the deal.

**Morgan:** Dangerous but practical.

**Alex:** Welcome to startup life. Okay, let's get building. Sarah, schedule the Week 2 preview with RetailFlow.

**Sarah:** Already on it. Thanks everyone!

[Meeting Ends]