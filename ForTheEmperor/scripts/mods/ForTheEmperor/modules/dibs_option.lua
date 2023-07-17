local mod = get_mod("ForTheEmperor")

mod:hook("SmartTagSystem", "reply_tag", function(fun, self, tag_id, replier_unit, reply_name)
	if mod:get("disable_dibs") and reply_name == "dibs" then
		local tag = self._all_tags[tag_id]

		self:cancel_tag(tag_id, tag._tagger_unit)

		self:set_tag(tag._template.name, replier_unit, tag._target_unit)
	else
		fun(self, tag_id, replier_unit, reply_name)
	end
end)
