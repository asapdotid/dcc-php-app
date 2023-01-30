##@ [Application: Commands]

# @see https://stackoverflow.com/a/43076457
.PHONY: restart-php-fpm
restart-php-fpm: ## Restart the php-fpm service
	"$(MAKE)" execute-in-container DOCKER_SERVICE_NAME=$(EXECUTE_IN_APPLICATION_CONTAINER) COMMAND="kill -USR2 1"

.PHONY: restart-workers
restart-workers: ## Restart all workers
	$(EXECUTE_IN_APPLICATION_CONTAINER) supervisorctl restart all

.PHONY: stop-workers
stop-workers: ## Stop all workers
	$(EXECUTE_IN_APPLICATION_CONTAINER) supervisorctl stop worker:*

.PHONY: start-workers
start-workers: ## start all workers
	$(EXECUTE_IN_APPLICATION_CONTAINER) supervisorctl start worker:*

.PHONY: execute-in-container
execute-in-container: ## Execute a command in a container. E.g. via "make execute-in-container DOCKER_SERVICE_NAME=php-fpm COMMAND="echo 'hello'"
	@$(if $(DOCKER_SERVICE_NAME),,$(error DOCKER_SERVICE_NAME is undefined))
	@$(if $(COMMAND),,$(error COMMAND is undefined))
	$(EXECUTE_IN_ANY_CONTAINER) $(COMMAND)

.PHONY: clear-queue
clear-queue: ## Clear the job queue
	$(EXECUTE_IN_APPLICATION_CONTAINER) php artisan queue:clear $(ARGS)
