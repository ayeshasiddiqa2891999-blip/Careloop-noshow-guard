# Careloop Clinics: No-Show Guard
Repository:https://github.com/ayeshasiddiqa2891999-blip/Careloop-noshow-guard
## Summary:
-Task 1: Cleaning ---> " I cleaned the raw booking file from 1020 rows down to 990 rows by removing 20 duplicates and 10 rows with unreadable dates or blank statuses and filled missing ages and distances with the median.
-Task 2:SQL--->"The highest no-show rate among at least 95 appointments, the highest no-show rate was Hadapsar Care Centre in Pune(27.3%), and no-shows rose from 16.2% for bookings made 1-7 days ahead to 60.5% for bookings made31+ days ahead and also I also found out that without having Gomti nagar carepoin(Lucknow) has the highest no-show rate(33.3%)
                but only 90 apponitments. With a small sample, a few no-shows change the percentage a lot so this is less relaible than those of larger clinics."

-Task 3: Model--> "I chose logistic regression because it had the highest cross-validated ROG-AUC(0.77) and at a threshold of 0.35 it flags 49 out of 198 test bokkings with precision 0.57and recall 0.57."
--Task 4: GenAI --> " Gemini labelled the 9 non-blank notes, and its root causes agreed with the expected ones for 7 notes of 9 notes; 2 notes were 
forgot or no reminder; and both belong to appointments where reminder_sent was No. And 3out of 10 notes belong to appointments with reminder_sent=No"

 ## Recommendation
CareLoop should first phone the bookings the model flags on the evening before
the appointment, and send reminders for bookings made far ahead, because 60.5%
of bookings made 31+ days ahead are missed, against 16.2% for bookings made
1-7 days ahead. At a threshold of 0.35, the model flags 49 of 198 test
bookings, which means about 49 calls per 198 bookings. The call-centre notes
point to missed reminders as a leading cause: 2 of the 9 non-blank notes were
"forgot or no reminder", and both of those bookings had no reminder sent.

## Model and threshold
I chose logistic regression because it had the highest cross-validated ROC-AUC
(0.774), ahead of the random forest (0.767) and the depth-3 tree (0.678). On
the test set its ROC-AUC was 0.79. I chose a threshold of 0.35 using
out-of-fold predictions on the training set only: it raised recall from 0.25
to 0.47 and F1 from 0.35 to 0.49, at the cost of more flagged bookings (154
vs 73). The test set was used once.

## Limitations
1. The 10 call-centre notes are only an illustration and cannot show the real
   reasons clinic-wide.
2. The same patient can appear in both the training and test sets, and the
   split is random, not past-to-future, so the test result may be too
   optimistic.
3. The threshold really depends on how many calls the front desk can make in
   an evening, and the data are observational, so the findings are
   associations, not causes.
