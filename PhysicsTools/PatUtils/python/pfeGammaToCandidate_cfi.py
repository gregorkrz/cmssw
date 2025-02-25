import FWCore.ParameterSet.Config as cms

pfeGammaToCandidate = cms.EDProducer("PFEGammaToCandidate",
    electrons = cms.InputTag("electrons"),
    photons = cms.InputTag("photons"),
    electron2pf = cms.InputTag("particleBasedIsolation","gedGsfElectrons"), 
    photon2pf = cms.InputTag("particleBasedIsolation","gedPhotons"), 
    #pf2pf = cms.InputTag("FILLME")
)
