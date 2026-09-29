import 'package:flutter/material.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  final _topics = const [
    _Topic(
      icon: Icons.savings_outlined,
      title: 'What is budgeting?',
      subtitle: '8 min read',
      tag: 'Basics',
      content: '''What is Budgeting?

Budgeting is the practice of creating a financial plan that outlines how you will earn, spend, and save your money over a specific period — usually a month.

Think of it as a roadmap for your money. Without it, your money has no direction, and you often end up wondering where it all went.

─────────────────────────────

Why Budgeting Matters

1. Stops You From Overspending
Without a budget, it is incredibly easy to spend more than you earn. A budget sets clear limits so you know exactly when to stop.

2. Reduces Financial Stress
Money worries are one of the biggest sources of stress for students. Knowing you have a plan — even a simple one — provides peace of mind.

3. Helps You Reach Goals Faster
Whether it is saving for a new device, a holiday, or simply building an emergency fund, budgeting allocates money towards your goals intentionally rather than by accident.

4. Builds Discipline and Awareness
The simple act of writing down what you spend builds a habit of mindfulness about your money. This habit, if built young, can change your financial life.

─────────────────────────────

How to Create Your First Budget

Step 1: Calculate Your Income
List all the money coming in: pocket money from parents, part-time job salary, freelance work, grants, or scholarships. Add it all up — this is your total monthly income.

Step 2: List Your Fixed Expenses
These are expenses that are the same every month: rent, phone bill, transport passes, subscription services (Netflix, Spotify), tuition fees. Write them all down.

Step 3: List Your Variable Expenses
These change each month: groceries, eating out, clothing, entertainment, personal care items. Look at your bank statements from the past 2-3 months to get a realistic average.

Step 4: Subtract Expenses From Income
  Income - (Fixed + Variable Expenses) = What You Have Left

If the result is negative, you are spending more than you earn. If it is positive, allocate that surplus to savings or debt repayment.

Step 5: Adjust Until It Balances
Look for places to cut. Can you reduce eating out? Cancel an unused subscription? The goal is not to deprive yourself but to be intentional.

Step 6: Track and Review Weekly
A budget is not a set-and-forget document. Check it every week. Life changes, and your budget should too.

─────────────────────────────

Common Budgeting Mistakes to Avoid

• Being Too Strict: If your budget feels like a punishment, you will abandon it. Build in guilt-free "fun" money.
• Forgetting Irregular Expenses: Birthdays, annual subscriptions, and medical costs happen. Set aside a small monthly amount for these.
• Not Tracking: The best budget in the world fails without follow-through. Use PennyPal's transaction tracker to stay accountable.
• Giving Up After One Bad Month: A rough month does not mean budgeting failed. Reset and try again.

─────────────────────────────

The Bottom Line

Budgeting is not about restriction. It is about freedom — the freedom to spend on what matters to you without guilt, and the confidence of knowing your future is under control.''',
    ),
    _Topic(
      icon: Icons.compare_arrows,
      title: 'Needs vs. wants',
      subtitle: '6 min read',
      tag: 'Basics',
      content: '''Needs vs. Wants: The Cornerstone of Smart Spending

Understanding the difference between needs and wants is the single most important concept in personal finance. Master this, and you will make better money decisions for the rest of your life.

─────────────────────────────

What Are Needs?

Needs are things that are essential for your survival, basic functioning, and ability to work or study.

Examples of Needs:
• Housing: Rent, utility bills (electricity, water, heating)
• Food: Basic groceries and essential meals
• Transport: Bus pass or fuel to get to school/work
• Healthcare: Essential medications, doctor visits
• Basic clothing: Functional clothes appropriate for work/school
• Education costs: Tuition fees, required textbooks

─────────────────────────────

What Are Wants?

Wants are things that enhance your life, bring enjoyment, or provide convenience — but you could survive without them.

Examples of Wants:
• The newest smartphone when your current one works fine
• Eating at restaurants instead of cooking at home
• Branded and designer clothing
• Video game subscriptions, streaming services
• Impulse purchases
• Expensive coffee drinks every morning

─────────────────────────────

The Tricky Grey Zone

This is where most people struggle. Many wants disguise themselves as needs.

Example 1: "I need a car."
→ But do you actually need a personal car, or do you need transportation? Public transit, cycling, or carpooling might meet the real need at a fraction of the cost.

Example 2: "I need the new iPhone."
→ You need a phone that works and connects you. You want the newest model. There is a big difference.

Example 3: "I need to eat out today."
→ You need food. But eating at a restaurant is the more expensive option. Cooking at home meets the need at a lower cost.

Ask yourself this question: "If I did not have this, would I be unable to survive or function at school/work?" If the honest answer is no — it is a want.

─────────────────────────────

A Practical System: OHIO (Only Handle It Once)

When you see something you want to buy, use this framework:

1. Pause for 24 to 48 hours before buying anything non-essential.
2. Ask: Do I need this, or do I want this?
3. Ask: Is it in my budget?
4. Ask: Does buying this help me reach my goals, or set them back?

If it passes all four checks, you can buy it guilt-free.

─────────────────────────────

Why This Matters for Students

As a student, your income is usually limited. Distinguishing needs from wants means:

• Your needs are ALWAYS covered first
• You save for goals without feeling deprived
• You avoid debt caused by impulsive want-purchases
• You build financial discipline that carries into adulthood

The students who master this one concept tend to graduate with savings, not debt.''',
    ),
    _Topic(
      icon: Icons.timeline_outlined,
      title: 'The 50/30/20 rule',
      subtitle: '7 min read',
      tag: 'Strategy',
      content: '''The 50/30/20 Rule: A Simple Framework for Balanced Finances

Popularised by U.S. Senator and bankruptcy expert Elizabeth Warren in her book "All Your Worth," the 50/30/20 rule is one of the most well-known and beginner-friendly budgeting strategies ever created.

It tells you exactly how to split your after-tax income into three buckets.

─────────────────────────────

The Three Buckets

50% → Needs
This half of your income goes to essential, non-negotiable expenses.

What counts:
• Rent or housing costs
• Groceries (basic, not fancy)
• Utility bills (electricity, water, gas)
• Transport to school or work
• Minimum debt repayments
• Healthcare essentials

Important: If your needs consistently eat up more than 50%, it is a red flag. It means either your income is too low for your lifestyle, or your "needs" category contains hidden wants.

─────────────────────────────

30% → Wants
This chunk is for the enjoyable parts of life. The goal is not to eliminate spending on wants — it is to keep it reasonable.

What counts:
• Dining out and cafes
• Shopping and clothing beyond basics
• Entertainment (streaming, concerts, hobbies)
• Gym memberships or sports
• Travel and holidays
• Gifts for others

This is your "fun budget." Spend it with zero guilt — as long as you stay within the 30%.

─────────────────────────────

20% → Savings and Debt Repayment
This is the most important bucket for your future.

What it covers:
• Emergency fund contributions
• Savings goals (new laptop, holiday, first apartment deposit)
• Extra payments on student loans or credit cards
• Investments (even small amounts add up over time)

"Pay yourself first" is the golden rule here: transfer this 20% on the day you get paid, before anything else.

─────────────────────────────

Real Example for a Student

Monthly take-home income: £800

• 50% Needs = £400: Rent £250, groceries £80, transport £50, phone £20
• 30% Wants = £240: Eating out £80, streaming £20, clothing £60, hobbies £80
• 20% Savings = £160: Emergency fund £60, holiday savings £60, student loan overpayment £40

─────────────────────────────

Is 50/30/20 Right for Every Situation?

Adjust based on your reality:
• High rent city? Try 60/20/20 temporarily while you build income.
• Debt-heavy? Shift to 50/20/30 to attack debt faster.
• Living at home with low expenses? Try 40/20/40 to supercharge savings.

The percentages are a guide, not a law. What matters is that you are intentionally allocating every rupee, pound, or dollar to something meaningful.

─────────────────────────────

Getting Started

1. Calculate your monthly take-home income.
2. Multiply by 0.5, 0.3, and 0.2 to get your three target amounts.
3. Create categories in PennyPal's Budget section for Needs, Wants, and Savings.
4. Track for one month.
5. Review and adjust.

That is all it takes to start.''',
    ),
    _Topic(
      icon: Icons.account_balance_outlined,
      title: 'Emergency funds 101',
      subtitle: '7 min read',
      tag: 'Saving',
      content: '''Emergency Funds 101: Your Financial Safety Net

Imagine this: Your laptop breaks the week before your final assignment is due. Or you get sick and need medicine you did not budget for. Or your part-time job suddenly cuts your hours.

Without an emergency fund, any of these events can spiral into a financial crisis — borrowing from family, going into debt, or missing important obligations.

An emergency fund prevents that.

─────────────────────────────

What is an Emergency Fund?

An emergency fund is a dedicated pool of money set aside exclusively for unexpected, unavoidable expenses. It is NOT money for planned purchases or lifestyle upgrades.

True emergencies include:
• Medical bills or urgent healthcare
• Urgent travel (family emergency)
• Essential item replacement (laptop for work/study, broken phone)
• Sudden loss of income
• Car or home repairs

NOT emergencies:
• A sale you do not want to miss
• A spontaneous trip with friends
• Upgrading to a newer model phone

─────────────────────────────

How Much Do You Need?

The standard financial advice is 3 to 6 months of living expenses. But as a student, that can feel overwhelming — so break it down into stages.

Stage 1 — Beginner Buffer: £200 to £500
This protects you against small, common emergencies. This is your first target.

Stage 2 — Solid Foundation: 1 month of expenses
Once you have your buffer, build toward covering one full month of essential costs.

Stage 3 — Fully Funded: 3 to 6 months of expenses
Your long-term target. At this level, you can handle a job loss or major crisis without going into debt.

─────────────────────────────

Where Should You Keep It?

The emergency fund has three requirements:
1. Safe (not invested in stocks — you cannot risk losing it)
2. Accessible (you can reach it within 1-2 days without penalties)
3. Separate (not in your everyday account — too easy to dip into)

Best Options:
• A dedicated savings account with your bank
• A high-yield savings account (HYSA) if available in your country — these pay more interest while keeping your money accessible
• NOT under your mattress (no interest, not safe)
• NOT in a stocks and shares ISA (too volatile, not instantly accessible)

─────────────────────────────

How to Build It Fast as a Student

The challenge for students is that income is often tight. Here is how to build it systematically:

1. Automate a Small Transfer: Set up a standing order on pay day — even £10 or £20/month. You will not miss what you never see.
2. Save Windfalls: Birthday money, bursaries, refunds, and tax rebates go straight into the emergency fund first.
3. Sell Unused Items: Old textbooks, electronics, and clothes you no longer use can quickly add £50-200 to your fund.
4. Use a Savings Challenge: Try saving £1 in week 1, £2 in week 2, and so on. By week 26, you will have saved £351.

─────────────────────────────

The Psychology of the Emergency Fund

Knowing you have an emergency fund changes how you feel about money. Anxiety is replaced with confidence. That psychological benefit alone is worth the effort of building it.''',
    ),
    _Topic(
      icon: Icons.school_outlined,
      title: 'Managing student expenses',
      subtitle: '9 min read',
      tag: 'Students',
      content: '''Managing Student Expenses: The Complete Guide

Student life comes with a unique financial challenge: you have adult-level expenses but often only a fraction of adult-level income. Here is how to handle it like a pro.

─────────────────────────────

Category 1: Housing (Usually Your Biggest Expense)

• Choose wisely at the start: The cheapest accommodation that still feels safe and comfortable will save you thousands over the year.
• Get a housemate: Splitting rent with one or more people dramatically reduces your biggest monthly cost.
• Negotiate: Student private landlords often have flexibility, especially if you are a reliable tenant. Always ask if there is any flexibility.
• Watch utility bills: Turn off lights, take shorter showers, and use energy-efficient settings. Even saving £15/month is £180/year.

─────────────────────────────

Category 2: Food (Where Most Students Overspend)

• Meal prep on Sundays: Spending 2 hours preparing food for the week saves money and time. Batch-cook rice, pasta, curries, and soups.
• Stick to a shopping list: Go to the supermarket with a list and a budget. Never shop when hungry.
• Reduce eating out to 1-2 times a week maximum: This single habit can save you £100-150 per month.
• Buy own-brand products: Supermarket own-brands are almost always identical to name-brands in quality but cost 20-40% less.
• Use student discount apps: Apps like UNiDAYS and Student Beans give discounts at hundreds of restaurants.
• Freeze bread and leftovers: Reduce food waste — food in the bin is literally money in the bin.

─────────────────────────────

Category 3: Transport

• Walk or cycle whenever possible: Free transport is the best transport.
• Get a student railcard: In the UK, a £30 railcard saves you 30% on all rail travel. It pays for itself on the first long journey.
• Use student bus passes: Many cities offer discounted or free bus travel for students. Check with your university.
• Avoid taxis and ride shares for regular commutes: They are convenient but brutally expensive compared to public transit.

─────────────────────────────

Category 4: Textbooks and Study Supplies

• Buy used or rent: New textbooks are expensive. Always check for used copies on Amazon, Facebook Marketplace, or your university's noticeboard.
• Use the library: Your university library often has copies of required textbooks. Borrow them — they are free.
• PDF versions: Many older textbooks have free PDF versions available legally. Your university library may also offer digital access.
• Split costs with classmates: If a book is needed for just a few chapters, split the cost with a friend.

─────────────────────────────

Category 5: Subscriptions and Entertainment

• Audit your subscriptions quarterly: Add up every monthly subscription you pay. Students are often shocked by the total. Cancel anything you have not used in a month.
• Use student pricing: Spotify, Apple Music, Amazon Prime, and many others have student plans that cost 40-50% less.
• Free entertainment: Museums, student film societies, university events, and parks are free. Take advantage.

─────────────────────────────

Category 6: Avoiding Debt Traps

• Credit cards: Useful only if you pay the full balance every single month. If you cannot, the interest turns small purchases into expensive ones.
• Buy Now Pay Later (BNPL): Services like Klarna feel harmless but can lead to unmanageable debt quickly. Use only if you have the money saved already.
• Overdrafts: Student overdrafts are often 0% interest — but only temporarily. Know when yours expires and have a plan to clear it.

─────────────────────────────

The Student Finance Mindset

The students who finish university in the best financial shape are not those who earned the most. They are the ones who spent intentionally, avoided lifestyle inflation, and made smart small decisions consistently.

Every £5 you save today, invested at even a modest rate of return, becomes significantly more over time.''',
    ),
    _Topic(
      icon: Icons.trending_up,
      title: 'Building good money habits',
      subtitle: '7 min read',
      tag: 'Habits',
      content: '''Building Good Money Habits: Small Actions, Massive Results

The difference between people who are financially comfortable and those who always feel broke is rarely income. It is habits. The habits you build in your student years compound over decades into either financial security or financial stress.

─────────────────────────────

Habit 1: Pay Yourself First

The moment your income arrives, transfer a predetermined amount to savings — before you pay bills, before you buy groceries, before anything else.

This is called "paying yourself first," and it fundamentally reframes your relationship with money. Instead of saving "whatever is left at the end of the month" (which is usually nothing), you save first and live on the rest.

Start with even 5-10% of your income. Automate it so it requires zero willpower.

─────────────────────────────

Habit 2: The Weekly Money Date

Set aside 15 minutes once a week — same day, same time — to review your finances. During this time:

• Check your PennyPal dashboard
• Review transactions from the past week
• Compare spending against your budget
• Adjust if needed

This habit is the single most powerful thing you can do to stay on track. People who review their finances weekly save more and feel less stressed about money than those who avoid looking.

─────────────────────────────

Habit 3: The 24-48 Hour Rule

When you see something you want to buy that is not on your planned list, wait 24 to 48 hours before purchasing.

Why it works:
• Impulse purchases rely on emotional momentum. A short delay breaks the emotional charge.
• After 24 hours, most impulse wants simply disappear. If you still want it after two days, it may genuinely be worth buying.
• It gives you time to check if it fits your budget.

This single habit can eliminate 80% of impulse spending.

─────────────────────────────

Habit 4: Track Every Transaction

People who track their spending consistently save significantly more than those who do not — even without changing any other behaviour. The act of writing down a £4 coffee makes you conscious of it. That consciousness alone influences future choices.

Use PennyPal's transaction tracker. Log every purchase on the same day, while it is fresh. Over time, you will spot patterns ("I spend HOW much on coffee?") and naturally adjust.

─────────────────────────────

Habit 5: Increase Savings with Every Income Rise

Whenever your income goes up — a pay rise, a new part-time job, a bursary — resist the temptation to upgrade your lifestyle proportionally. Instead:

• Keep your expenses the same
• Direct the extra income to savings or debt repayment

This is called avoiding "lifestyle inflation" and it is one of the most powerful wealth-building strategies that exists. A student who earns £200 more per month and saves £150 of it will be in a completely different financial position in two years than one who simply spends the extra £200.

─────────────────────────────

Habit 6: Learn Continuously

The best investment you can make is in your own financial education. Spend 15-20 minutes per week reading about personal finance. Some excellent free resources:

• Books: "The Psychology of Money" by Morgan Housel; "I Will Teach You to Be Rich" by Ramit Sethi
• Podcasts: "How to Money", "Planet Money", "The Meaningful Money Podcast"
• This Learning Hub in PennyPal

─────────────────────────────

Habit 7: Talk About Money

Money is a taboo topic in many cultures — and that taboo keeps people financially ignorant. Talk to trusted friends about financial habits. Compare strategies. Learn from each other.

─────────────────────────────

The Compound Effect of Habits

None of these habits produce dramatic results overnight. But:

• 24-hour rule → saves £30/month
• Weekly money date → identifies £20/month in waste
• Tracking everything → reduces overspending by £25/month
• Paying yourself first → adds £50/month to savings

Together: £125/month more saved, which is £1,500/year — without earning a single extra pound.

That is the compound effect of small, consistent habits. Start today.''',
    ),
    _Topic(
      icon: Icons.credit_card_outlined,
      title: 'Understanding debt & credit',
      subtitle: '8 min read',
      tag: 'Advanced',
      content: '''Understanding Debt & Credit: Friend, Foe, or Both?

Debt is one of the most misunderstood concepts in personal finance. It is simultaneously one of the most powerful financial tools available and one of the most dangerous. Understanding the difference between good debt and bad debt — and how credit works — is essential for any financially literate person.

─────────────────────────────

What is Debt?

Debt is simply money that you have borrowed and are obligated to repay, usually with interest.

Key terms you need to know:
• Principal: The original amount borrowed
• Interest: The fee charged for borrowing money, expressed as a percentage (APR — Annual Percentage Rate)
• Minimum Payment: The lowest amount you must pay each month to stay in good standing
• Credit Limit: The maximum amount you are allowed to borrow on a credit product

─────────────────────────────

Good Debt vs. Bad Debt

Not all debt is equal. A useful framework is to distinguish between debt that builds your future value and debt that erodes it.

Good Debt (generally):
• Student loans: You are borrowing to invest in an education that will increase your earning power. The interest is often subsidised and repayment is tied to income.
• A mortgage: Borrowing to buy an asset (property) that may appreciate in value over time.
• A business loan: Borrowing capital to generate more income.

Bad Debt (generally):
• Credit card debt carried month-to-month: High interest rates (often 20-30% APR) on purchases that provide no long-term value.
• Buy Now Pay Later: Easy to overuse, and missed payments damage your credit score.
• Payday loans: Extremely high APR (sometimes over 1000%). These should be avoided entirely.

Rule of thumb: If the interest rate on the debt is higher than the return you could earn by investing that money, it is almost always better to pay off the debt first.

─────────────────────────────

How Interest Actually Works (The Maths That Matters)

Example: £1,000 credit card debt at 25% APR, minimum payments only.

At a minimum payment of approximately £25/month:
• It takes over 6 years to repay
• You pay back roughly £1,800 total — nearly DOUBLE the original debt

But if you pay £100/month:
• You repay in about 11 months
• You pay roughly £1,120 total

The difference is £680 in interest charges — just from paying more each month. This is why carrying high-interest debt is so destructive.

─────────────────────────────

What is a Credit Score?

A credit score is a number (typically 0 to 999 in the UK, or 300 to 850 in the US) that represents how trustworthy you are as a borrower. Lenders use it to decide whether to approve loans and at what interest rate.

Factors that affect your credit score:
• Payment history (35%): Do you pay bills on time? This is the biggest factor.
• Credit utilisation (30%): How much of your available credit are you using? Below 30% is ideal.
• Length of credit history (15%): Older accounts help.
• Types of credit (10%): A mix of different credit types can help.
• New credit enquiries (10%): Too many applications in a short time can hurt your score.

─────────────────────────────

How to Build Credit as a Student

If you have no credit history, it can be hard to borrow when you need to. Here is how to build it responsibly:

1. Get a student credit card with a low limit
2. Use it ONLY for one small, regular purchase (e.g., your monthly streaming subscription)
3. Set up a direct debit to pay the FULL balance every month automatically
4. Never miss a payment

This builds credit history without the risk of accumulating debt.

─────────────────────────────

The Golden Rules of Debt

1. Only borrow what you can afford to repay
2. Always pay more than the minimum payment on high-interest debt
3. Prioritise paying off the highest-interest debt first (avalanche method)
4. Never use debt to fund a lifestyle — only for genuine investments
5. Check your credit report annually for free (Experian, Clearscore, Credit Karma)''',
    ),
    _Topic(
      icon: Icons.rocket_launch_outlined,
      title: 'Introduction to investing',
      subtitle: '10 min read',
      tag: 'Advanced',
      content: '''Introduction to Investing: Making Your Money Work for You

If saving is important, investing is transformational. Saving keeps your money safe. Investing grows it. Understanding even the basics of investing as a student can completely alter your long-term financial trajectory.

─────────────────────────────

Why Should Students Think About Investing?

Because of compound growth — the most powerful concept in all of personal finance.

Compound growth means you earn returns not just on your original investment, but on all the previous returns too. Over time, this creates exponential growth.

A simple example:
• £1,000 invested at 8% annual return
• After 10 years: £2,159
• After 20 years: £4,661
• After 40 years: £21,724

That is the same initial £1,000 growing to over £21,000 — without adding another penny. The secret is time.

This is why starting young, even with tiny amounts, is so powerful. A 20-year-old who invests £50/month will almost certainly end up wealthier than a 35-year-old who invests £200/month — simply because they started earlier.

─────────────────────────────

Key Investment Concepts

Risk and Return
Every investment involves a trade-off between risk (the chance of losing money) and potential return (the chance of gaining money). Generally:
• Higher potential return = Higher risk
• Lower risk = Lower potential return

Diversification
"Do not put all your eggs in one basket." Spreading investments across different asset types, industries, and countries reduces the risk of any single investment wiping out your portfolio.

Asset Classes
• Cash and savings: Safe but low return (inflation can erode real value)
• Bonds: Loans to governments or companies; generally lower risk than stocks
• Stocks/Equities: Ownership in companies; higher potential returns but higher volatility
• Property: Can provide rental income and capital appreciation; requires significant capital
• Index Funds: A basket of many stocks that tracks a market index — widely considered the best starting point for beginners

─────────────────────────────

Index Funds: The Beginner's Best Friend

Instead of picking individual stocks (which requires expertise and research), an index fund simply buys a small piece of every company in a market index (like the FTSE 100 or S&P 500).

Benefits:
• Instantly diversified across hundreds of companies
• Low fees (often as low as 0.1-0.2% per year)
• Historically strong long-term performance
• No expert knowledge required

The S&P 500 (500 largest US companies) has historically returned an average of approximately 10% per year. Past performance does not guarantee future results, but it is a useful benchmark.

─────────────────────────────

How to Start as a Student

Step 1: Clear high-interest debt first
There is no point investing at 8% if you are paying 25% on credit card debt. Pay off bad debt first.

Step 2: Build your emergency fund first
Never invest money you might need in the next 1-2 years. The market can drop 30-40% in the short term.

Step 3: Open an investment account
• In the UK: A Stocks and Shares ISA (tax-free growth up to £20,000/year)
• Platforms like Vanguard, Freetrade, or InvestEngine are beginner-friendly
• Some allow you to start with as little as £1

Step 4: Choose a low-cost index fund
• Vanguard FTSE Global All Cap Index Fund
• iShares Core MSCI World ETF
• Both give you exposure to thousands of companies worldwide

Step 5: Invest regularly (pound-cost averaging)
Invest the same amount every month, regardless of what the market is doing. This strategy automatically buys more shares when prices are low and fewer when prices are high — averaging out your cost over time.

─────────────────────────────

Things Beginner Investors Must Know

• Investing is for the long term: 5+ years minimum. The stock market can be volatile short-term but has historically always gone up long-term.
• You will see your portfolio go down: This is normal. Do not panic and sell. Time in the market beats timing the market.
• Beware of get-rich-quick schemes: If someone promises guaranteed 50% monthly returns, it is a scam. Run.
• Keep costs low: High fees eat into returns. Always check the fund's expense ratio.
• This is not financial advice: Always do your own research or consult a qualified financial advisor for personal guidance.

─────────────────────────────

The Bottom Line

You do not need to be rich to start investing. You do not need to be an expert. You need patience, consistency, and time. The best day to start was yesterday. The second best day is today.''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Learning Hub', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Build money skills, one lesson at a time.',
                  style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.55), fontSize: 13)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: _topics.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (_, i) => _buildTopicCard(context, _topics[i], colorScheme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, _Topic topic, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => _LessonDetailScreen(topic: topic)),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(topic.icon, size: 22, color: colorScheme.onSurface),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(topic.tag,
                        style: TextStyle(fontSize: 11, color: colorScheme.primary, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 6),
                  Text(topic.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(topic.subtitle,
                      style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurface.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}

// Full-screen lesson detail page — much better than a dialog for long content
class _LessonDetailScreen extends StatelessWidget {
  final _Topic topic;
  const _LessonDetailScreen({required this.topic});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary.withValues(alpha: 0.8), colorScheme.primary.withValues(alpha: 0.4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(topic.tag,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 8),
                        Text(topic.title,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(topic.subtitle,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                topic.content,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  color: colorScheme.onSurface.withValues(alpha: 0.87),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _Topic {
  final IconData icon;
  final String title;
  final String subtitle;
  final String tag;
  final String content;
  const _Topic({required this.icon, required this.title, required this.subtitle, required this.tag, required this.content});
}
