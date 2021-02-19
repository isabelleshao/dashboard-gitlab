<template>
    <div class = "header">
        <div class = "sticky">
            <h1>Filters</h1> 
        </div>
    </div>
    
</template>

<script>
export default{
    name: "FilterPanel"
}
</script>

<style scoped>
    .header {
        width:20vw;
        background: rgba(223,223,223,0.100);
        color: black;
        text-align: center;

    }

    .sticky{
        position: -webkit-sticky;
        position: sticky;
        top: 5em;
    }
</style>