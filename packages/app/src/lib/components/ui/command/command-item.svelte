<script lang="ts">
	import { cn } from '$lib/utils.js'
	import { Command as CommandPrimitive } from 'cmdk-sv'

	type $$Props = CommandPrimitive.ItemProps

	export let asChild = false

	let className: string | undefined | null = undefined
	export { className as class }
</script>

<CommandPrimitive.Item
	{asChild}
	class={cn(
		'relative flex cursor-default select-none items-center rounded-none px-2 py-1.5 text-sm outline-none aria-selected:bg-accent aria-selected:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
		className,
	)}
	{...$$restProps}
	let:action
	let:attrs
>
	<slot {action} {attrs} />
</CommandPrimitive.Item>
