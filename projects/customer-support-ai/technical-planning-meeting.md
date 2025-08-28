# Technical Planning Meeting - TechSupport Pro AI Platform
**Date:** January 22, 2025  
**Attendees:** Engineering Team, Product, Marcus (Sales)  
**Duration:** 75 minutes

## Meeting Transcript

**Marcus (Sales):** Thanks everyone for joining. Quick update - TechSupport Pro loved the initial demo. They want to start a pilot next week with 2 agents. We need a working Zendesk integration ASAP.

**Riley (Product):** Next week? That's aggressive. What are the absolute must-haves?

**Marcus:** AI-suggested responses in Zendesk, their knowledge base ingested, and basic analytics. They're sharing 1,000 anonymized tickets tomorrow for testing.

**Sam (Engineering Lead):** I've looked at Zendesk's API. We can build an app for their marketplace or use the sidebar SDK. The sidebar is faster to implement.

**Riley:** Let's go sidebar. What about the AI model?

**Jordan (ML Engineer):** I'm thinking GPT-4 for understanding queries and Claude for generating responses. We'll need a vector database for their knowledge base. Pinecone or Weaviate?

**Sam:** Pinecone. We already have it running from the last project. Jordan, how long to ingest their knowledge base?

**Jordan:** If it's 2,000 articles, maybe 4-5 hours to chunk, embed, and index. The real work is building the retrieval pipeline.

**Alex (Backend):** We need to think about the architecture. Every ticket triggers an AI call? That's expensive and slow.

**Jordan:** We should cache common questions. If we see "how to export reports" 50 times, we cache that response.

**Riley:** Smart. But responses need to be contextual. Can't just return the same answer to everyone.

**Jordan:** Right. We'll cache the knowledge retrieval but regenerate the response with context each time. Best of both worlds.

**Marcus:** They also want sentiment analysis. Angry customers get flagged for immediate attention.

**Jordan:** That's straightforward. We can use the sentiment analysis API from AWS Comprehend or run a small BERT model locally.

**Sam:** AWS Comprehend is faster to implement. We can switch later if needed.

**Casey (Frontend):** What about the agent interface? How do they interact with suggestions?

**Riley:** Three buttons: Accept, Modify, Reject. If they modify, we learn from that. Also need confidence scores displayed.

**Casey:** I'll need a few days for the Zendesk app UI. Their SDK is... not great.

**Sam:** I'll handle the Zendesk integration backend. Casey focuses on the UI. We divide and conquer.

**Marcus:** They're very concerned about accuracy. Lisa mentioned a bad experience with chatbots giving wrong answers.

**Jordan:** We need a confidence threshold. Below 80% confidence, we flag it for human review. Above 95%, we can auto-suggest strongly.

**Riley:** Good idea. Let's also add an "explanation" feature - agents can see why the AI suggested something.

**Jordan:** That means we need to track which knowledge base articles were used. More complex but doable.

**Alex:** What about the infrastructure? They want US-only data.

**Sam:** Everything in US-East-1. No exceptions. We'll need to document this clearly for their security review.

**Marcus:** Speaking of security, they want an audit trail of every AI interaction.

**Alex:** PostgreSQL for the audit log. Every suggestion, acceptance, modification gets logged with timestamps and user IDs.

**Riley:** They also mentioned Spanish support. 30% of their customers.

**Jordan:** That's tricky. We either need a multilingual model or translation layer. Translation is faster to implement but less accurate.

**Riley:** Let's start with translation for the pilot and plan for native Spanish support in Phase 2.

**Sam:** Agreed. What about the analytics dashboard?

**Casey:** I can build a simple React dashboard. What metrics matter?

**Marcus:** Response time improvements, suggestion acceptance rate, tickets resolved by category, and sentiment trends.

**Casey:** Give me 3 days for a basic version. Can make it prettier later.

**Jordan:** We need to talk about the feedback loop. When agents modify suggestions, how do we improve?

**Riley:** Log everything but don't auto-retrain yet. Weekly reviews of modifications to identify patterns.

**Jordan:** Makes sense. Manual curation for now, automation later.

**Alex:** What about rate limiting? If all agents hit us simultaneously?

**Sam:** Queue with Redis. SQS as backup. Process tickets async with webhooks back to Zendesk.

**Marcus:** They want to see response times under 2 seconds. Is that realistic?

**Jordan:** For cached queries, yes. For new queries, 3-5 seconds is more realistic with RAG.

**Sam:** We can show a "thinking" indicator. Sets expectations.

**Riley:** What about testing? We need to be absolutely sure about accuracy.

**Jordan:** I'll build an evaluation suite. Run their 1,000 tickets through, measure accuracy, identify failure modes.

**Sam:** We also need load testing. They handle 500 tickets daily.

**Alex:** I'll set up K6 for load testing. Simulate 100 concurrent tickets, see what breaks.

**Marcus:** They want a pilot dashboard to track success metrics. Different from agent analytics.

**Casey:** Another dashboard? Okay, but it'll be basic.

**Riley:** That's fine. Just need to show ROI clearly.

**Jordan:** Question about the knowledge base - is it structured? PDFs? HTML?

**Marcus:** Mix of everything. Confluence pages, PDFs, some Word docs. It's a mess.

**Jordan:** Great. I'll need parsers for everything. Add 2 days to my estimate.

**Sam:** What about versioning? Their knowledge base probably updates frequently.

**Jordan:** Good point. We need incremental indexing. Can't re-index everything daily.

**Riley:** MVP can be daily full re-index. Incremental is Phase 2.

**Alex:** What about monitoring? This is business critical for them.

**Sam:** DataDog for metrics, Sentry for errors, PagerDuty for alerts.

**Riley:** Don't forget user training. We need documentation and videos.

**Casey:** I can record Loom videos once the UI is stable.

**Marcus:** They want to start with 2 agents but scale to all 12 quickly if successful.

**Sam:** The architecture should handle that. Horizontal scaling on ECS.

**Jordan:** The vector database might be a bottleneck. Need to capacity plan.

**Alex:** Let's over-provision for the pilot. Better safe than sorry.

**Riley:** Okay, let's prioritize. Week 1 deliverables?

**Sam:** Zendesk integration working end-to-end.

**Jordan:** Knowledge base ingested and searchable.

**Casey:** Basic UI for suggestions in Zendesk.

**Alex:** Infrastructure deployed and monitored.

**Marcus:** That gets us to pilot launch. What about week 2?

**Riley:** Analytics dashboard, sentiment analysis, Spanish translation.

**Sam:** Performance optimization and caching layer.

**Jordan:** Evaluation suite results and accuracy improvements.

**Casey:** Agent training materials and documentation.

**Riley:** Sounds like a plan. Any blockers?

**Jordan:** Need access to their Zendesk sandbox ASAP.

**Marcus:** I'll get that today.

**Sam:** Also need sample knowledge base articles for testing.

**Marcus:** They're sending 100 articles tomorrow with the tickets.

**Alex:** What about error handling? If OpenAI is down?

**Jordan:** Fallback to cached responses. If that fails, graceful degradation message.

**Riley:** Good. Never leave agents hanging.

**Casey:** One more thing - they mentioned Slack integration?

**Sam:** Phase 2. Let's nail Zendesk first.

**Riley:** Agreed. Focus wins deals.

**Marcus:** Last question - they want to train the AI on their specific product. How?

**Jordan:** Fine-tuning is overkill. RAG with their documentation should be sufficient. We can add few-shot examples for their common patterns.

**Riley:** Perfect. Everyone clear on next steps?

**Team:** Yes.

**Riley:** Daily standups at 10am. This is our top priority. Marcus, keep TechSupport Pro updated on progress.

**Marcus:** Will do. They're excited but nervous. Let's not let them down.

[Meeting Ends]