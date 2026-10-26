import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
P=pd.read_csv(ROOT/"data/pslm_person_subset.csv")
H=pd.read_csv(ROOT/"data/pslm_hh_subset.csv")
D=P.merge(H[["hhid","hhweight","prov_code","urban_rural"]],on="hhid",how="inner")
D=D[(D.prov_code==4)&(D.urban_rural==2)&D.age.between(15,64)&np.isfinite(D.earn_annual)&(D.earn_annual>0)&np.isfinite(D.hhweight)&(D.hhweight>0)].copy()
D["start"]=((D.age-15)//5)*5+15
D["age_band"]=D.start.astype(str)+"-"+(D.start+4).astype(str)
rows=[]
for start in range(15,65,5):
 z=D[D.start==start]
 rows.append({"age_band":f"{start}-{start+4}","midpoint":start+2,"n_earners":len(z),"weighted_mean_earnings":round(np.average(z.earn_annual,weights=z.hhweight)) if len(z) else np.nan,"thin":len(z)<30})
S=pd.DataFrame(rows)
S.to_csv(ROOT/"figures/q5_python_age_band_table.csv",index=False)
fig,ax=plt.subplots(figsize=(10,6)); rng=np.random.default_rng(346)
ax.scatter(D.age+rng.uniform(-.35,.35,len(D)),D.earn_annual,s=13,alpha=.22,linewidths=0)
ax.plot(S.midpoint,S.weighted_mean_earnings,marker="o",linewidth=1.7)
for _,r in S[S.thin].iterrows(): ax.scatter([r.midpoint],[r.weighted_mean_earnings],facecolors="none",edgecolors="black",s=65,zorder=5)
top=S.loc[S.weighted_mean_earnings.idxmax()]
ax.annotate(f"Highest mean: {top.age_band}",(top.midpoint,top.weighted_mean_earnings),xytext=(-75,20),textcoords="offset points",arrowprops={"arrowstyle":"->"})
ax.set_yscale("log"); ax.set_ylim(1e4,1e7); ax.set_xlim(14,65); ax.set_xticks(range(15,66,5)); ax.set_xlabel("Age (years)"); ax.set_ylabel("Annual earnings (rupees, log scale)"); ax.set_title("Annual earnings by age band — urban Balochistan"); ax.grid(axis="y",alpha=.2); fig.tight_layout(); fig.savefig(ROOT/"figures/q5_python_age_profile.svg",format="svg")
print(S.to_string(index=False))
