SXSWDemo
========

This is a quick little iPhone app to show how to exercise all of the Navigation Solutions web services.

The main functionality is contained in the Services/NavSolService and Service/NavSolServicesManager classes.
The easiest way to use a service is to create a Service object and pass it to the [[NavSolServicesManager instance]
callService] message. Before that, you should register with the NSNotifcationCenter "serviceCallFinished" notification to know when a service call has completed. At that point, the response data will be contained in [[NavSolServicesManager instance] recievedData]. That's all there is to it!

