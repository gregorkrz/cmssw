import FWCore.ParameterSet.Config as cms

pfEGammaToCandidateRemapper = cms.EDProducer("PFEGammaToCandidate",
    electrons = cms.InputTag("gedGsfElectrons"),
    photons = cms.InputTag("gedPhotons"),
    #electron2pf = cms.InputTag("particleBasedIsolation","gedGsfElectrons"), 
    #photon2pf = cms.InputTag("particleBasedIsolation","gedPhotons"), 
    #pf2pf = cms.InputTag("FILLME")
)
