# Policy Driven Risk Reduction in Unregulated Small Business Cloud Environments

## Abstract and Background
During the past decades, computing infrastructure has made seismic shifts: from a server in a closet, to collocated data centers, to dedicated data centers, and to the latest frontier of the cloud. In this process, large organizations have had teams of engineers working to maintain and secure their infrastructure, but small businesses do not have the capability to match this level of staffing. Where large enterprise teams have hundreds of employees working on applications and infrastructure projects, a small business may have a team of just a few supporting custom, in-house applications and off the shelf solutions in addition to the infrastructure required to operate. In this light, I am to create a set of actionable security policies that can be applied across public cloud providers in an automated fashion. These policies, driven by a analysis of known attacks and a threat model of possible attack vectors, aims to help small business who are not required to be compliant with regulations such as Payment Card Industry Data Security Standards (PCI-DSS) or under the regulation of European Union’s General Data Protection Regulations (GDPR). This is a starting point for businesses who may have limited or no policies nor methods to automate enforcement of policies by leveraging solutions that can be applied to disparate public cloud providers.

## How to use this repository:

To use, simply download each folder as required for your cloud environment. It is recommended to use Windows Subsystem for Linux or another Bash environment.
You will also need Steampipe and the associated platform plugin (one each for AWS, Azure, and GCP) and Terraform installed as well as the appropriate CLI tool(s) such as AzureCLI or AWS tools.
<br />

After downloading, cd into the appropriate folder and enter 'terraform init' to ensure you are authenticated.
Next enter 'terraform plan' to view the outcome of the changes and finally 'terraform apply' to make these changes in your cloud environment.
<br />

* Note: you can use 'terraform apply -destroy' to remove deployed resources

After getting confirmation of deployment, you can use Steampipe to check the security status of your environment.
To use the CIS benchmarks, simply run 'steampipe check benchmark.cis_v140' for response sent to the console or use 'steampipe check benchmark.cis_v140 > output.txt' to save the results for review. 


## Policy Recommendations


Data-1 | Protect data stores against external access. Access should only be granted to applications and authorized internal users. This should apply to customer records as well as infrastructure logging data stores.

Data-2 | Map where all sensitive data is held.

Infra-1 | Infrastructure should be immutable in production instances.

Infra-2 | Ensure all communication is encrypted wherever possible.

Infra-3 | Infrastructure should be decoupled from storage. Processes should not rely on local storage to ensure scalability and segregated data storage.

Infra-4 | Base operating system images should be gold images from cloud providers that are regularly updated.

Infra-5 | Resources should not be exposed to the internet unless explicitly required.

Ops-1 | All resources should be labelled with an approved tagging schema. For example: one environment tag such as test, production, and sandbox and a owner tag which could be 
an email to the deploying team. These tags allow us to monitor and apply policies per environment and notify impacted users.

Ops-2 | Backups should be stored in a separate account with different credentials to ensure integrity of backup data.

Ops-3 | Test backups every quarter to ensure business recovery is possible.

Ops-4 | Ensure at least one person has emergency access to remove resources if needed.

Ops-5 | Internal users should have the least amount of privileges, and administrators should be limited to managers.

Ops-6 | Review the environment every quarter to ensure all resources are still required.

Ops-7 | Enable multifactor authentication for all internal users.

Ops-8 | Periodically review all users and resources for appropriate level of access.
