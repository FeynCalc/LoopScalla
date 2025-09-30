* Here we define particles appearing in the Feynman rules

* Quarks
F Qi, Qj, Qu, Qd, Qs, Qc, Qt, Qb, Qibar, Qjbar, Qubar, Qdbar, Qsbar, Qcbar, Qtbar, Qbbar;

* Charged leptons
F Lei, Lej, Nlei, Nlej, El, Mu, Tau, Nel, Nmu, Ntau, Alei, Alej, Anlei, Anlej, Ael, Amu, Atau, Anel, Anmu, Antau;

* Neutrinos
F Nlei, Nlej, Nle, Nel, Nmu, Ntau, Anlei, Anle, Anlej, Anel, Anmu, Antau;

* Ghosts
F Gh, GhGa, GhZ, GhWp, GhWm, Ghbar, GhGabar, GhZbar, GhWpbar, GhWmbar;

* Vector bososn
F Ga, Gl, Wp, Wm, Z;

* Goldstones
F H, Gb, Gbp, Gbm;

* These sets simplify the application of Feynman rules by grouping
* multiple similar rules into a single id statement

* The ordering of the particles in the sets lsclXXXFields and lsclAntiXXXFields
* must match, so that each position of a particle in one set corresponds to the
* position of its antiparticle in the other set

set lsclQuarkFields: Qu, Qd, Qs, Qc, Qt, Qb, Qi, Qj;
set lsclAntiQuarkFields: Qubar, Qdbar, Qsbar, Qcbar, Qtbar, Qbbar, Qibar, Qjbar;

set lsclChargedLeptonFields: El, Mu, Tau, Lei, Lej;
set lsclAntiChargedLeptonFields: Ael, Amu, Atau, Alei, Alej;

set lsclNeutrinoFields: Nel, Nmu, Ntau, Nlei, Nlej;
set lsclAntiNeutrinoFields: Anel, Anmu, Antau, Anlei, Anlej;

set lsclLeptonFields: El, Mu, Tau, Lei, Lej, Nel, Nmu, Ntau, Nlei, Nlej;
set lsclAntiLeptonFields: Ael, Amu, Atau, Alei, Alej, Anel, Anmu, Antau, Anlei, Anlej;

set lsclEWGhostFields: GhGa, GhZ, GhWp, GhWm;
set lsclAntiEWGhostFields: GhGabar, GhZbar, GhWpbar, GhWmbar;

set lsclAntiParticleLeptonicCurrentP: Anel, Anmu, Antau;
set lsclParticleLeptonicCurrentP: El, Mu, Tau;

set lsclAntiParticleLeptonicCurrentM: Ael, Amu, Atau;
set lsclParticleLeptonicCurrentM: Nel, Nmu, Ntau;

set lsclAntiUpQuark: Qubar, Qcbar, Qtbar;
set lsclUpQuark: Qu, Qc, Qt;

set lsclAntiDownQuark: Qdbar, Qsbar, Qbbar;
set lsclDownQuark: Qd, Qs, Qb;

set lsclGoldstoneBosonFields: H, Gb, Gbp, Gbm;
set lsclEWBosonFields: Ga, Wp, Wm, Z;

set lsclScalarFields: H, Gb, Gbp, Gbm;
set lsclVectorFields: Ga, Gl, Wp, Wm, Z;
set lsclFermionFields: Qu, Qd, Qs, Qc, Qt, Qb, Qi, Qj, El, Mu, Tau, Lei, Lej, Nel, Nmu, Ntau, Nlei, Nlej;
set lsclAntiFermionFields: Qubar, Qdbar, Qsbar, Qcbar, Qtbar, Qbbar, Qibar, Qjbar, Ael, Amu, Atau, Alei, Alej, Anel, Anmu, Antau, Anlei, Anlej;
set lsclGhostFields: Gh, GhGa, GhZ, GhWp, GhWm;
set lsclAntiGhostFields: Ghbar, GhGabar, GhZbar, GhWpbar, GhWmbar;

* Here we define the coupling constants and masses
* It is better to define everything that may appear inside a reduction
* code as all lowercase variables, since FIRE cannot handle capital letters

* In SM we have 9 lepton and quark masses, 1 Higgs mass and 3 couplings (gs, el, g) and 1 Higgs VEV
* g can be traded for sin(theta_W) via g=el/sW.
S sW, cW, gs, el, lsclGaugeXiEw, mw, mz, mh, mqu, mqd, mqs, mqc, mqt, mqb, mel, mmu, mtau, mqi, mqj, mli, mlj;

* ckmV is the CKM matrix V_xy. In SM it depends on 3 angles (theta_{12,13,23}) 
* and 1 CP-violating phase delta
CF ckmV;

