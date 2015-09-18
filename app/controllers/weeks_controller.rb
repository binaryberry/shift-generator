class WeeksController < ApplicationController

	def index
		@week=Week.new
		@weeks=Week.all
	end
end
